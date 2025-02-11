require "import"
import "java.io.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "android.content.Context"
import "com.androlua.LuaMultiAdapter"

--[[脚本器启动 或 自行添加主题中启动 
  _rime_emoji: {label: 表情, functional: false, send: function, command: "emoji.lua"}
  本脚本为获取网络表情
  https://www.emojiall.com/zh-hans/
  
  常用界面：长按emoji 单个删除 ，长按 "常用" 按钮， 删除全部
  长按名称按钮 快速到底部
  ]]
--import "script.lua键盘.function.功能键" --导入功能键
require("script.lua键盘.function.功能键")

local 圆角度=20
local 边框厚度=3
local 边框颜色=0xFF000000
local 背景颜色=0xFFC7D5EF
local 高亮颜色=0xFEC13000

local function colorDrawable(背景颜色)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(边框厚度, 边框颜色) -- 边框厚度和边框颜色
  drawable.setColor(背景颜色) -- 背景颜色
  drawable.setCornerRadius(圆角度) -- 圆角
  return drawable
end

local EmojiPath=service.getLuaExtDir("")
local emoji_path = debug.getinfo(1,"S").source:sub(2)
local dir = string.match(emoji_path, "(.+[/\\])")
local emojiFile = dir .. "/_emoji常用.txt"

local function floor(width)
 return math.floor(width) .. "px"
end

pcall(function()
  --键盘自适应高度，旧版中文不支持，放pcall里防报错
  Keyboard_height=service.getLastKeyboardHeight()
end)
local Keyboard_width = this.getWidth()
local gnwidth = "200"
local emwidth = floor(Keyboard_width - gnwidth)
local gnw = floor(gnwidth)

local layout=
{
  FrameLayout;
  layout_height=Keyboard_height;
  layout_width="fill";
  {
    LinearLayout;
    layout_height=Keyboard_height/4*3;
    layout_width=emwidth;
    {
      GridView;
      id="emoji_grid";
      -- gravity="center";
      numColumns=5,
      -- fastScrollEnabled = true,
    };
  };

  {
    LinearLayout;
    orientation="horizontal";
    layout_gravity="bottom";
    {
      LinearLayout;
      layout_width="15%w";
      id="common",
    },
    {
      HorizontalScrollView;
      layout_height=Keyboard_height/4;
      layout_width="65%w";
      {
        LinearLayout;
        orientation="horizontal";
        id="horizontalScrol";
      };
    };
  };

  {
    LinearLayout;
    layout_width=gnw;
    --layout_height="fill";
    orientation="vertical";
    layout_gravity="right";
    id="emojign",
  };
};

layout=loadlayout(layout)

local item=
{
  LinearLayout;
  layout_height=Keyboard_height/4;
  layout_width=Keyboard_width/6;
  gravity="center";
  -- Background="#FFFF17E2",
  {
    TextView;
    id="emoji_items",
    text="加载中……",
    textSize="30sp";
    textColor = "#ffff0000";
  },
}

local function setAdapter(data)
  adp = LuaAdapter(service, data, item)
  emoji_grid.Adapter = adp
end

--爬取emoji
local function getEmojiList(url)
  Http.get(url, nil, 'utf8', nil, function(code, sourceCode)
    if code == 200 and sourceCode then
      setAdapter(data)
      sourceCode = string.gsub(sourceCode, 'https:', 'http:')
      local contentRange = sourceCode:match([[<div class='emoji_card_list pages'>  <div(.-)class='emoji_card_list pages'><div]])
      if not contentRange then
        print("内容范围未匹配成功")
        return
      end
      local data = {}
      adp.clear()
      --table.clear(data)
      for s in contentRange:gmatch([[class="emoji_font">(.-)</a><]]) do
        table.insert(data, s)
      end
      for i = 1, #data do
        adp.add{ emoji_items = data[i] }
      end
      adp.notifyDataSetChanged()
     else
      print("数据加载失败")
    end
  end)
end


--getEmojiList("https://www.emojiall.com/zh-hans/categories/A")


local isCommonScreen = false --是否为 "常用" 界面
local highlightedButton = nil -- 保存当前被高亮的按钮

--emoji名称按键
local function createCategoryButton(categoryName, url)
  local button = Button(service)
  local buttonText = string.sub(categoryName, 1, 11) -- 截取字符串的前 11字符
  button.setText(buttonText)
  button.setBackgroundDrawable(colorDrawable(背景颜色))

  -- 创建布局参数对象并设置外边距
  local params = button.getLayoutParams()
  if params == nil then
    params = LinearLayout.LayoutParams(
    LinearLayout.LayoutParams.WRAP_CONTENT,
    LinearLayout.LayoutParams.WRAP_CONTENT
    )
  end
  params.setMargins(5, 0, 5, 2) -- 设置外边距
  button.setLayoutParams(params)

  button.onClick = function(view)
    local textView = TextView(service)

    -- 恢复之前高亮的按钮背景颜色
    if highlightedButton ~= nil then
      highlightedButton.setBackgroundDrawable(colorDrawable(背景颜色))
    end

    -- 高亮当前按钮背景颜色
    button.setBackgroundDrawable(colorDrawable(高亮颜色))
    highlightedButton = button -- 更新当前高亮的按钮

    getEmojiList(url, function(data) textView.setText(data) end )

    isCommonScreen = false
  end
  button.onLongClick = function(view)
    task(10,function()
      emoji_grid.setSelection(emoji_grid.getCount()-1)--滚动到底部
    end)
    return true
  end

  return button
end

--常用
local function updateAdapter()
  setAdapter(data)
  local emojiFileRead = io.open(emojiFile, "r")
  adp.clear()
  local lines = {} -- 存储读取到的内容

  if emojiFileRead then
    for line in emojiFileRead:lines() do
      table.insert(lines, line) -- 将内容存入表中
    end
    emojiFileRead:close()
  end

  -- 倒序显示
  for i = #lines, 1, -1 do
    local line = lines[i]
    adp.add{ emoji_items = line }
  end
  isCommonScreen = true
  adp.notifyDataSetChanged()
end

updateAdapter()

--emoji名称
function insertCategoryButtons()
  local baseUrl = "https://www.emojiall.com/zh-hans/categories/"
  local categoryLetter = "A"
  for i = 1, 10 do
    local url = baseUrl .. categoryLetter
    Http.get(url, nil, 'utf8', nil, function(code, sourceCode)
      if code == 200 and sourceCode then
        sourceCode = string.gsub(sourceCode, 'https:', 'http:')
        local metaTagContent = sourceCode:match("<meta%s+property=\"article:tag\"%s+content=\"([^\"]+)\"")
        if metaTagContent then

          horizontalScrol.addView(createCategoryButton(metaTagContent , url))
         else
          print("未找到Meta标签内容")
        end
      end
    end)
    -- 将最后一个字母从 A 到 J 递增
    categoryLetter = string.char(categoryLetter:byte() + 1)
  end
  
  local usedButton = createCategoryButton("常用", "")
  usedButton.setBackgroundDrawable(colorDrawable(0xFFE7E8EC))
  common.addView(usedButton)
  usedButton.onClick = function(view)
    updateAdapter()
    if highlightedButton ~= nil then
      highlightedButton.setBackgroundDrawable(colorDrawable(背景颜色))
    end
    -- 高亮当前按钮背景颜色
    usedButton.setBackgroundDrawable(colorDrawable(高亮颜色))
    highlightedButton = usedButton
  end

  local function showPopupMenu(view)
    local pop = PopupMenu(service, view)
    local menu = pop.Menu
    menu.add("清除全部内容").onMenuItemClick = function(a)
      -- 清空 emojiFile 文件的全部内容
      local emojiFileWrite = io.open(emojiFile, "w")
      if emojiFileWrite then
        emojiFileWrite:close()
      end
      updateAdapter()
      print("已清除全部内容")
    end
    menu.add("取消").onMenuItemClick = function(a)
      print("取消操作")
    end
    pop.show()
  end

  usedButton.onLongClick = function(view)
    showPopupMenu(view)
    return true
  end

end

insertCategoryButtons()

--点击事件
emoji_grid.onItemClick = function(l, v, p)
  local clickedText = v.Tag.emoji_items.text

  -- 检查是否已经记录过该内容
  local isDuplicate = false
  local emojiFileRead = io.open(emojiFile, "r")
  if emojiFileRead then
    for line in emojiFileRead:lines() do
      if line == clickedText then
        isDuplicate = true
        break
      end
    end
    emojiFileRead:close()
  end

  if not isDuplicate then
    -- 写入新内容到emojiFile
    local emojiFileWrite = io.open(emojiFile, "a")
    if emojiFileWrite then
      emojiFileWrite:write(clickedText .. "\n")
      emojiFileWrite:close()
    end
  end

  service.commitText(clickedText)
  return true
end

emoji_grid.onItemLongClick = function(l, v, p)
  local clickedText = v.Tag.emoji_items.text

  -- 判断当前界面是否为 "常用" 界面
  if isCommonScreen then
    -- 删除常用界面的内容
    local emojiFileRead = io.open(emojiFile, "r")
    if emojiFileRead then
      local lines = {}
      for line in emojiFileRead:lines() do
        if line ~= clickedText then
          table.insert(lines, line)
        end
      end
      emojiFileRead:close()

      local emojiFileWrite = io.open(emojiFile, "w")
      if emojiFileWrite then
        for _, line in ipairs(lines) do
          emojiFileWrite:write(line .. "\n")
        end
        emojiFileWrite:close()
      end

      updateAdapter() -- 更新适配器
    end
   else

    service.commitText(clickedText)
  end

  return true
end
local 参数={
 圆角度 = 20,
 边框厚度 = 0,
 边框颜色 = 0xFF000000,
 背景颜色 = 0xFFF7F7F9,
 高亮颜色 = 0xFEC13000,
 }

--功能键
createButtons(emojign,参数)

--service.setKeyboard(layout)

return layout