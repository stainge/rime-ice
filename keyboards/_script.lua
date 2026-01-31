require "import"
import "java.io.*"
import "android.app.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "android.content.*"
--import "script/dex/martext:android.widget.MarText"
--import "script/dex/martext:android.app.*"

local 说明={[[
脚本启动-极简版
]]}

local 显示全部 = false -- true 显示全部lua文件包括子文件夹内
local 显示路径 = false --只针对全部显示 true 显示路径

local Keyboard_height = "240dp"
pcall(function()
  --键盘自适应，旧版中文不支持，放pcall里防报错
  Keyboard_height=service.getLastKeyboardHeight()
end)
local Keyboard_width = this.getWidth()
local hide_height = this.getCandidateView().getHeight()--获取候选栏

local function ShowLuaError(luaFilePath)
  -- local success, result = xpcall(function()
    -- dofile(luaFilePath) end,
  -- debug.traceback)
  local success, result = pcall(dofile, luaFilePath)
  if not success then
    -- 错误发生，result为错误信息
    local errorText = "错误：" .. tostring(result)
    local errorDialog = LuaDialog(this)
    .setCancelable(true)
    .setTitle("错误提示")
    .setMessage(errorText)
    .setPositiveButton("返回",{onClick=function(v)
        this.sendEvent("Keyboard_default")
    end})
    .setNegativeButton("取消",nil)
    .setNeutralButton("复制",{onClick=function(v)
        service.getSystemService(Context.CLIPBOARD_SERVICE).setText(errorText)
        print("复制成功")
    end})
    .create()
    errorDialog.show()
    -- 输出详细的错误信息
    --print(debug.traceback())
    return
  end
end
import "android.graphics.drawable.GradientDrawable"
function RadiuButton(color, radius)
  local shape = GradientDrawable()
  shape.setShape(GradientDrawable.RECTANGLE)
  shape.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  shape.setColor(color)
  return shape
end


local file = service.getLuaExtDir("script")

local function rescript(file)
  local fscript = File(file).list({
    accept = function(dir, name)
      if name:match("%.lua$") then
        return File(dir, name).isFile()
      end
      return false
    end
  })
  return fscript
end

--全部
local function findLuaFiles(folder)
  local files = {}
  local function search(folder)
    local list = folder.listFiles()
    local fst = luajava.astable(list)
    for _, file in ipairs(fst) do
      if file.isDirectory() then
        search(file)
       elseif file.getName():match("%.lua$") then
        -- if 显示路径 == true then
        table.insert(files, file.getPath()) --路径+名称
        -- else
        --  table.insert(files, file.getName())
        --end
      end
    end
  end
  search(folder)
  return files
end

local layout=
{
  LinearLayout;
    orientation="0";
  layout_height="fill",
  layout_width="fill",
  id="yex",
  {
    ScrollView;
    layout_height="fill",
    -- layout_width="fill",
    layout_weight="1",
    layout_margin="5dp";
    --overScrollMode=View.OVER_SCROLL_NEVER,
    VerticalScrollBarEnabled=false,
     -- ScrollBarStyle="outsideOverlay|left",
     -- ScrollIndicators=View.SCROLL_INDICATOR_TOP,
     --ScrollBarSize=15,
    id="sorll";
  };
  {
    LinearLayout;
    orientation="vertical";
    id="gnButton";
    -- padding="5dp";
    layout_width="200";
    layout_height="fill";
    layout_gravity="right|center";
  };
  {
    TextView;
    id="cent";
    text="移动控件",
    layout_height="100",
    layout_width="180",
    layout_margin="5dp";
    gravity="top|center";
    Visibility=8,
    BackgroundDrawable=RadiuButton(0xFF47BACD, 50),
  },
};

local layout=loadlayout(layout)

local function reGnkey()
  local function gnkey(t)
    local gnbutton ={
      Button;
      text=t;
      textSize='13sp';
      textColor='#333333';
      layout_width="65dp";
      layout_height="45dp";
      AllCaps = false,
      id = "bnt",
    };
    return gnbutton
  end
  local gnItem={
    {name="", title="返回"},
    {name=KeyEvent.KEYCODE_SPACE, title="空格"},
    {name=KeyEvent.KEYCODE_DEL, title="删除"},
    {name=true, title="All"},
    {name=KeyEvent.KEYCODE_ENTER, title="回车"},
  }
  for n,t in ipairs(gnItem) do
    local gnbutton = gnkey(t.title)
    gnButton.addView(loadlayout(gnbutton))
    bnt.onClick=function(v)
      if t.title == "返回" then
        --  this.setKeyboard(".default")
        service.setKeyboard(Config.get().getKeyboardNames()[0] )
       elseif t.title == "All" then
        if v.text == "All" then
          v.setText("script")
          显示全部=t.name
         else
          v.setText("All")
          显示全部=false
        end
        reItem()
        sorll.fullScroll(ScrollView.FOCUS_UP)
       else
        this.onKey(t.name, 0)
      end
    end
  end

end
reGnkey()

function reItem()
  local aa={
    GridLayout;
    layout_width="fill",
    layout_height="wrap";
    columnCount="3",
    id = "gcC",
  };

  local function vv(a)
    local pa = string.match(a, "(.+[/\\])")
    if 显示路径 == false then
      if pa ~= nil then
        a = string.gsub(a, pa, "")
      end
     else
      a = a
    end
    i= {
      Button;
      background="#ceFFFFFF";
      text=a;
      id ="aaa",
      layout_width=service.getWidth()/3 - 80,
      layout_height="wrap";
      gravity="center";
      layout_gravity="center";
      layout_margin="2dp";
      padding="5dp";
      textSize="13sp";
      -- singleLine = true,
      AllCaps = false,
      onClick=function()
        -- local path = string.match(a, "(.+[/\\])")
        if 显示路径 == false then
          if pa ~= nil then
            ShowLuaError(pa..a)
           else
            ShowLuaError(tostring(file).."/"..a)
          end
         else
          if pa ~= nil then
            ShowLuaError(a)
           else
            ShowLuaError(tostring(file).."/"..a)
          end
        end
      end
    };
    table.insert(aa,i)
  end

  sorll.removeAllViews()
  if 显示全部 == true then
    -- 全部lua显示
    fs = findLuaFiles(File(tostring(file)))
   else
    -- 不显示子文件夹内lua文件
    fs = luajava.astable(rescript(file))
  end
  if fs ~= nil then
    for k, v in ipairs(fs) do
      vv(v)
    end
    sorll.requestLayout()
   else
    print("没有找到任何文件")
  end
  sorll.addView(loadlayout(aa))
  
  if 显示全部 == true then
  if 显示路径 == true then
    gcC.setColumnCount(3)
    gcC.scrollBy(0,0)
   else
    gcC.setColumnCount(3)
    --gcC.scrollBy(-50,0)
  end
 else
  
  gcC.scrollBy(10,0)
end
end

reItem()



--cent.setVisibility(0)

sorll.setOnScrollChangeListener{
  onScrollChange=function (view, a, b, c)
    local sorllHeight = view.getHeight() - cent.getHeight()
    local scrollY = view.getScrollY()
    local childHeight = sorll.getChildAt(0).getHeight()
    
    local ycs = view.getHeight() - cent.getHeight()/2
    local ybs = view.getHeight()/cent.getHeight()
    local ycs2 = sorllHeight/((childHeight-sorllHeight)/b)
    
    if ycs2 > sorllHeight then
        ycs2 = view.getHeight()
    elseif ycs2 <= 0 then
        ycs2 = 0
    end
    cent.setY(ycs2)
    
    cent.setText(" ycs:"..ycs2..",\nb高:"..b..",总高:"..childHeight
    .."\n"..scrollY.."数量:"..#fs)
    -- gnButton.setVisibility(8)
    
    
    -- if scrollY <= 0 then
      -- gnButton.setVisibility(0)
     -- cent.setVisibility(8)
      -- elseif b >= childHeight - view.getHeight() then
      -- -- gnButton.setVisibility(0)
      -- cent.setVisibility(8)
    -- else
    -- cent.setVisibility(0)
    -- end

end }

function cent.onTouch(v, e)
  local ljpe = e.getAction()
  local cenh = v.getHeight()
  switch(ljpe)
   case MotionEvent.ACTION_DOWN
    xt1=e.getRawX()
    yt1=e.getRawY()
    xt2 = e.getX()
    yt2 = e.getY()
    seheigt = Keyboard_height - cent.getHeight()
    sorCh = sorll.getChildAt(0).getHeight()
    sorH = sorll.getHeight()
    yc1=sorll.getScrollY()
    v.setVisibility(0)
    return true
   case MotionEvent.ACTION_MOVE
   cent.setBackgroundDrawable(RadiuButton(0xFFFF8574, 50))
   local  yt3 =(sorCh/(sorH+cenh/2))* (e.getRawY() - yt1)
   local dy = e.getRawY() - yt1 -- 计算手指移动的距离
    local maxScrollY = sorCh - sorH + cenh -- 计算最大可滚动距离
    local scrollY = yc1 + dy * (maxScrollY / sorH) -- 计算新的滚动位置
    
    local distance = e.getRawY() -- 滑动距离
local content_length = sorCh -- 总内容长度
local visible_length = sorH -- 可视区域长度
local slider_length = cenh -- 滑块长度

local scroll_distance = scroll(distance, content_length, visible_length, slider_length)

    if yt3 > seheigt then
      yt3 = seheigt
      elseif yt3 < 0 then
      yt3 = 0
      end
    cent.setY(yt3)

    -- 限制scrollY不超过最大可滚动距离
    if scrollY > maxScrollY then
        scrollY = maxScrollY
    elseif scrollY < 0 then
        scrollY = 0
    end
    sorll.smoothScrollTo(0, scrollY)
   
   v.setText(scrollY.."\n"..scroll_distance)
    return true
   case MotionEvent.ACTION_UP
    v.setBackgroundDrawable(RadiuButton(0xFF47BACD, 50))
    --task(500, function() v.setVisibility(8) end)
  end
  return false
end
--cent.setOnTouchListener(onTouchListener2)


function scroll(distance, content_length, visible_length, slider_length)
    -- 计算滑动比例
    local slide_ratio = distance / (content_length - slider_length)

    -- 计算滚动距离
    local scroll_distance = slide_ratio * (content_length - visible_length)

    return scroll_distance
end

-- import "android.graphics.drawable.ColorDrawable"
 -- sorll.setVerticalScrollbarThumbDrawable(RadiuButton(0xFFB2DAEB, 50))--滑块
 -- sorll.setVerticalScrollbarTrackDrawable(RadiuButton(0xFFF4F4F4, 50))--轨道
 -- sorll.setVerticalScrollbarPosition(View.SCROLLBAR_POSITION_LEFT)--位置，默认 左右



return layout

