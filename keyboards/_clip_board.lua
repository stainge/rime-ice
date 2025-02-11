require "import"
import "java.io.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "com.osfans.trime.*" --载入包
import "android.content.Context"
import "com.luajava.*"
import "android.graphics.*"
import "android.os.Handler$Callback"
import "android.view.MotionEvent"
import "android.widget.ScrollView"
import "android.os.Handler"
import "android.widget.AdapterView"
import "java.lang.Runnable"
import "java.lang.Thread"
import "android.view.inputmethod.InputMethodManager"
import "android.widget.HorizontalListView"

import "android.text.Html"

local 说明={[[
文件放在 rime/keyboards 中
主题中添加，中文默认，应该都有
  _Keyboard_clip: {label: 剪贴板, send: Eisu_toggle, select: _clip_board}

剪贴板数量上限可自行修改 位置： local numkh =
数量设置：不一定及时生效，修改成重置键盘好像是没问题了，需要等等
首次启动可能会卡死，没用适配器，
单次刷新数量为：30 位置： local segmentSize = 30
剪贴板界面向下箭头 是滚动到底部，刷新下一组数据
标签文本规则位置： local function extract_info(str)
滚动刷新有点问题， scroll_lay.setOnScrollChangeListener
刷新时，切换到常用语，刷新依然存在，不切换就没问题
主文件： _clip_board.lua
悬浮窗口文件：_ClipBoardWindow.luas  
位置必须是 keyboards/ClipboardWindow文件夹下 
记录悬浮窗口位置： _ClipBoardWindow.xy.txt 
(点击空白移动-关闭才能自动创建，不影响使用)
窗口空白处：点击关闭窗口，按住移动窗口
]]}


local Keyboard_height = "240dp"
pcall(function()
  --键盘自适应，旧版中文不支持，放pcall里防报错
  Keyboard_height=service.getLastKeyboardHeight()
end)
local Keyboard_width = this.getWidth()
local candidate = this.getCandidateView().getVisibility()--获取候选栏显示状态
local hide_height = this.getCandidateView().getHeight()--获取候选栏
local clip_height = Keyboard_height + hide_height --剪贴板
local card_width = Keyboard_width-50

local ClipBColor = 0xFFE3E4E9
local TextColor = 0xFF000000
local CardBColor = 0xFFF7F7F9
local ButtonColor = 0xFFF4F4F4
local ButtonTextColor = 0xFF30C190
local TagTextColor = 0xFF5D5D5D
local TagBColor = 0xFFE9E9E9


import "android.widget.LinearLayout$LayoutParams"
local function 设置宽度(ID,宽度)
  linearParams=ID.getLayoutParams()
  linearParams.width=宽度
  ID.setLayoutParams(linearParams)
end

local function 设置高度(控件ID,高度)
  linearParams=控件ID.getLayoutParams()
  linearParams.height=高度
  控件ID.setLayoutParams(linearParams)
end

import "android.graphics.drawable.GradientDrawable"
local function RadiuButton(color, radius)
  local shape = GradientDrawable()
  shape.setShape(GradientDrawable.RECTANGLE)
  shape.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  shape.setColor(color)
  return shape
end

import "android.view.animation.DecelerateInterpolator"
import "android.view.animation.Animation"
import "android.animation.ObjectAnimator"
import "android.view.animation.AccelerateInterpolator"
import "android.view.animation.LinearInterpolator"

local function leftMoveAnimation(v)
  local 平移动画 = ObjectAnimator.ofFloat(v, "X", {0, -500})
  平移动画.setInterpolator(DecelerateInterpolator()) -- 动画插值器
  平移动画.setDuration(300) -- 动画时间
  平移动画.start() -- 动画开始
end

local function rightMoveAnimation(v)
  local 平移动画 = ObjectAnimator.ofFloat(v, "X", {1080, 550})
  平移动画.setInterpolator(DecelerateInterpolator()) -- 动画插值器
  平移动画.setDuration(300) -- 动画时间
  平移动画.start() -- 动画开始
end

local function 归位动画(v, x, y)
  local 平移动画 = ObjectAnimator.ofFloat(v, "X", {x, y})
  平移动画.setInterpolator(DecelerateInterpolator()) -- 动画插值器
  平移动画.setDuration(300) -- 动画时间
  平移动画.start() -- 动画开始
end



import "android.widget.CardView"
local function myCardView(ID, 文本, 边距, 圆角, click)
  local card={
    CardView;
    radius=圆角;
    layout_width="wrap";
    layout_height="wrap";
    layout_margin=边距;
    -- layout_weight="1";
    CardBackgroundColor=ButtonColor;
    Elevation="3";
    id=ID,
    onClick=function(v)
      click(v)
    end,
    {
      TextView;
      layout_gravity="center";
      layout_margin="10dp";
      text=文本;
      textSize="15sp";
      textColor=ButtonTextColor;
      singleLine="true";
    };
  };
  return card
end

local function myView()
  return{
    View,
    layout_width="wrap",
    layout_height="1px",
    layout_weight="1";
  }
end

local script_path = debug.getinfo(1,"S").source:sub(2)
local dir = string.match(script_path, "(.+[/\\])")
local path_rime = service.getLuaExtDir()
local path_clip = path_rime.."/clipboard.json"

local path_phr = path_rime.."/phrase.json"
local file = File(path_clip)
local file2 = File(path_phr)
local mList = JsonUtil.load(file)
local mphr = JsonUtil.load(file2)

local phrase = luajava.astable(mphr)
local clip = luajava.astable(mList)
local 剪贴板 = true
local temp = {} -- 创建一个临时表来存储加载的元素
local count = 0 -- 记录加载的数量
local index = 1 -- 记录当前的索引
local function load50()
 if #clip ~= 0 then
  for i = index, index + 49 do -- 从当前索引开始，循环 50 次
    local v = clip[i] -- 获取元素
    if v == nil then -- 如果元素为空，说明已经到达表的末尾
      break -- 跳出循环
    end
    count = count + 1 -- 增加计数器
    table.insert(temp, v) -- 把元素插入到临时表中
    -- table.remove(clip, i) -- 把元素从原表中删除
  end
  index = index + 50 -- 更新索引
 end
end

-- load50()

if mList.size() > 50 then
load50()
else
 temp = luajava.astable(mList)
end

local function ClipboardSize() --获取当前数量/设置的数量
  local file1 = io.open(path_clip, "r")
  local getSzie = this.getSharedData("clipboard_size")
  local lineCount = 0
  for line in file1:lines() do
    lineCount = lineCount + 1
  end
  file1:close()
  local size = lineCount - 2 or getSzie
  return {size=size, lineCount=lineCount - 2, getSzie=getSzie}
end
local 当前数量 = ClipboardSize().size
local 设置数量 = ClipboardSize().getSzie
if tostring(当前数量) == tostring(设置数量) then
  local 提示 = "剪贴板数量已达设置上限 " .. 当前数量 .. "/" .. 设置数量
  Toast.makeText(this,tostring(提示), 0).show()
end

local function extract_info(str)
  local name = str
  local email = str:match("[%w._%-%+]+@[%w.-]+%.[%w]+")
  local url = str:match("https?://[%w./-]+")
  local phone = str:match("%d%d%d%d%d%d%d%d%d%d%d")
  local emailcom = str:match("@(.+)")
  local emailname = str:match("(.-)@")
  local Word = str:gmatch("[%w_%.]+")
  local English_matches = {}
  if email then
    table.insert(English_matches, email)
  end
  if emailcom then
    table.insert(English_matches, emailcom)
  end
  if emailname then
    table.insert(English_matches, emailname)
  end
  if url then
    table.insert(English_matches, url)
  end
  if phone then
    table.insert(English_matches, phone)
  end
  for word_match in Word do
    if #word_match > 1 then
      table.insert(English_matches, word_match)
    end
  end
  local hash = {}
  local unique_matches = {}
  for _, match in ipairs(English_matches) do
    if not hash[match] then
      table.insert(unique_matches, match)
      hash[match] = true
    end
  end
  name = table.concat(unique_matches, "\n")

  return name
end

local layout1={
  LinearLayout;
  layout_height=clip_height;
  layout_width="fill";
  orientation="vertical";
  --BackgroundColor=ClipBColor;
  -- BackgroundDrawable=RadiuButton(ClipBColor, 20),
  {
    LinearLayout;
    layout_height=hide_height;
    layout_width="fill";
    layout_marginTop="5dp";
    orientation=0;
    myView(),
    myCardView("Set_clip", "⚙️", 0, 50 ),
    myView(),
    myCardView("scroll_down", " ⇩ ", 0, 50 ),
    myView(),
    {
      LinearLayout;
      layout_height="fill";
      layout_width="wrap";
      orientation=0;
      id="clip_common",
      myCardView("Clip_board", "剪贴板", "2dp", 20 ),
      myCardView("Com_words", "常用语", "2dp", 20 ),
    },
    myView(),
    myCardView("key_del", "⌫ ", 0, 50 ),
    myView(),
    myCardView("back", " ➥ ", 0, 50 ),
    myView(),
  };
  {
    FrameLayout;
    layout_height="fill";
    layout_width="fill";
    id= "clip_set_view",
    {
      ScrollView;
      layout_height="wrap";
      id="scroll_lay";
      layout_gravity="center";
      layout_width=card_width;
      layout_marginBottom="1dp";
      verticalScrollBarEnabled=false,--隐藏滑条
      {
        LinearLayout;
        layout_width="fill";
        layout_height="wrap";
        orientation="vertical";
        layout_marginTop="5dp";
        id="list";
      };
    };
    {
      ProgressBar,
      layout_width="fill",
      layout_height="10dp",
      layout_gravity="bottom";
      -- BackgroundColor=CardBColor;
      max="100",
      min="10",
      Visibility=8,
      indeterminate=true,
      id="pabr",
      secondaryProgress="15",
      style="?android:attr/progressBarStyleHorizontal"
    };
  };
};


local layout=loadlayout(layout1)

import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
pabr.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(0xFFFB7299,PorterDuff.Mode.SRC_ATOP))

--service.setKeyboard(layout)
local function setBackgroundDrawable(view, view1)
  clip_common.setBackgroundDrawable(RadiuButton(0xFFD7D8DD, 20))
  view.setBackgroundDrawable(RadiuButton(ButtonColor, 20))
  view1.setBackgroundDrawable(RadiuButton(0x00000000, 20))
  view.getChildAt(0).setTextColor(ButtonTextColor)
  view1.getChildAt(0).setTextColor(TextColor)
end

setBackgroundDrawable(Clip_board, Com_words)

function myTextView(p, t)
  local mytv={
    TextView;
    textSize="18sp";
    -- layout_height="fill";
    layout_width=card_width;
    layout_weight="1";
    -- layout_gravity="center";
    gravity="center";
    padding="10dp";
    MaxLines="2", --最大行数
    MaxEms="30",
    text=t, --Html.fromHtml(t);
    textColor=TextColor;
    -- singleLine = true,
    -- BackgrmListoundDrawable=RadiuButton(ButtonTextColor, 20),
    onClick = function(v)
      -- local p= p+1
      service.commitText(v.Text)
      if scroll_down.getVisibility() ~= 8 then
        if p>1 then
          mList.remove(p-1)
          mList.add(0,v.Text)
          -- scroll_lay.fullScroll(ScrollView.FOCUS_UP)
          -- init_cilp_wx(luajava.astable(mList))
          --  list.requestLayout()
          this.loadClipboard()
          JsonUtil.save(file, mList)
        end
      end
    end
  };
  return mytv
end

local window={
  FrameLayout;
  layout_width="fill",
  layout_height="wrap";
  --orientation="1";
  -- gravity="center";
  id="view_v_0",
  -- clickable=true;
  {
    LinearLayout;
    orientation="horizontal";
    layout_width=Keyboard_width-100,
    layout_height="wrap";
    id="liny_00";
    BackgroundDrawable=RadiuButton(0xed47BACD, 50),
    {
      TextView;
      textSize="12sp";
      padding="2dp";
      layout_marginLeft="5dp";
      layout_gravity="center|left";
      gravity="center";
      --Visibility=8,
      id="edpos",
      layout_height="wrap";
    };
    {
      FrameLayout;
      layout_height="10%h";
      layout_margin="5dp";
      id="frame_1";
      layout_width=Keyboard_width-400;
      BackgroundDrawable=RadiuButton(CardBColor, 15),
      {
        LuaEditor;
        layout_height="fill";
        --text="测试";
        layout_width="fill";
        --layout_weight="1";
        -- layout_gravity="bottom";
        --  BackgroundColor = CardBColor,
        padding="5dp";
        id="editText",
        -- clickable=true;
        --hint="tcbhh",
      };
    };
    {
      Button;
      layout_gravity="center";
      layout_width="50dp";
      layout_height="50dp";
      layout_margin="5dp";
      BackgroundDrawable=RadiuButton(0x50FFFFFF, 100),
      singleLine = true,
      textSize="12sp";
      text="保存";
      id="editBC",
    };
  },
  {
    LinearLayout;
    layout_gravity="right|top";
    layout_width="45dp";
    layout_height="45dp";
    -- layout_margin="5dp";
    BackgroundDrawable=RadiuButton(0x10FFFFFF, 100),
    --singleLine = true,
    clickable=false;
    --textSize="12sp";
    --text="缩放";
    id="view_v_2",
  },
}
local Managerlayout = loadlayout(window)

local function 打开输入法(控件)
  -- import "android.widget.*"
  -- import "android.view.*"
  -- import "android.content.*"
  --
  -- srfas = 控件.getContext().getSystemService(Context.INPUT_METHOD_SERVICE)
  -- srfas.toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
  local jiaodian=控件--设置焦点到编辑框
  jiaodian.setFocusable(true)
  jiaodian.setFocusableInTouchMode(true)
  jiaodian.requestFocus()
  jiaodian.requestFocusFromTouch()
end

--删除文本
local function removeText(str, file, mList)
  mList.remove(str)
  service.loadClipboard()
  JsonUtil.save(file, mList)
end

local function card_addText(num2)
  local view = list.getChildAt(num2 - 1)
  local cm1 = view.getChildAt(1)
  cm1.getChildAt(0).setText("修改")
end

function relayout(temp)
  list.removeAllViews()
  if #temp == 0 then
    import "android.widget.TextClock"
    local timeText = '剪贴板为空\n yyyy.MM.dd EEEE HH:mm:ss'
    list.addView(loadlayout({
      TextClock;
      textSize="20sp";
      layout_height="fill";
      layout_width="fill";
      gravity="center";
      Format24Hour=timeText;
      -- BackgroundColor=CardBColor;
    }))
   else
    for k, v in pairs(temp) do
      -- local a="<font color=\'#EE7700\'>"..v.."<font/>"
      local ctext, dtext = v, extract_info(v)
      -- local function itemView(p, t)
      local item= {
        LinearLayout;
        layout_width="fill";
        layout_height="fill";
        orientation="horizontal";
        gravity="center";
        Clickable=false,
        {
          CardView;
          Elevation="3";
          radius="20";
          layout_margin="5dp";
          CardBackgroundColor=CardBColor;
          id="card_one";
          layout_width="fill";
          layout_height="-1";
          -- MinimumHeight="50dp",
          -- layout_marginBottom="10dp";
          -- layout_weight="1";
          {
            LinearLayout;
            layout_width="fill";
            layout_height="wrap";
            -- layout_weight="1";
            -- layout_margin="5dp";
            -- MinimumHeight="80dp",
            orientation="vertical";
            BackgroundColor="#00ffEFEF";

            {
              LinearLayout;
              layout_height="fill";
              -- layout_weight="1";
              layout_width=card_width-50;
              layout_gravity="center";
              orientation="1";
              -- BackgroundColor="#ffffEFEF";
              -- {
              -- HorizontalScrollView;
              -- layout_height="wrap";
              -- layout_width="wrap";
              -- layout_gravity="center";
              -- paddingLeft="5dp";
              -- BackgroundColor="#00ffEFEF";
              -- horizontalScrollBarEnabled=false;
              -- id="text_hsv",
              {
                TextView;
                textSize="12sp";
                padding="2dp";
                text=tostring(k)..".";
                layout_height="wrap";
                layout_width="wrap";
                gravity="center";
                -- layout_height="fill";
                BackgroundColor=CardBColor;
              };
              {
                LinearLayout;
                layout_height="fill";
                layout_width="fill";
                layout_gravity="center";
                myTextView(k, ctext),
              };
              -- };
            };
            {
              LinearLayout;
              layout_width="wrap";
              layout_height="-1";
              --  layout_weight="1";
              MinimumHeight="1px",
              layout_gravity="center|bottom";
              -- layout_marginLeft="15dp";
              -- BackgroundColor="#ffff1234";
              id="textheight",
              {
                HorizontalListView;
                dividerWidth = "10dp"; -- 设置项之间的间距
                horizontalScrollBarEnabled=false;
                id="tag_list";
                layout_width=-1;
                layout_height="wrap";
                -- layout_marginBottom="3dp";
                layout_gravity="center|bottom";
                -- BackgroundColor="#ffffEFEF";
                --  items={},
              };
            };
          };

          {
            TextView;
            textSize="20sp";
            padding="5dp";
            -- layout_height="fill";
            layout_width="50dp";
            layout_gravity="right";
            BackgroundColor=CardBColor;
            text="︙";
            gravity="center";
            id="card_menu";
            onClick= function(v)
              MoveAnimation(v)
            end
          };

        };
        {
          LinearLayout;
          -- padding="5dp";
          Visibility=8,
          id="card_menu_1",
          layout_height="fill";
          layout_width= -10;
          gravity="center";
          {
            Button;
            BackgroundDrawable=RadiuButton(ButtonColor, 50),
            text="＋添加为常用语";
            -- layout_width="wrap";
            layout_weight="1";
            layout_height="wrap";
            gravity="center";
            textColor=ButtonTextColor;
            textSize="15sp";
            singleLine = true,
            AllCaps = false,
            id="card_add",
            onClick=function(v)
              if v.getText() == "修改" then
              local path = File(dir.."ClipboardWindow/_ClipBoardWindow.luas")
local filelua = path.getAbsolutePath()
    local trimeService = Trime.getService()
    local WindowManagers = trimeService.doFile(filelua)
    
            WindowManagers.clip_board_Window(Managerlayout)
                editText.setText(ctext)
                打开输入法(editText)
                edpos.setText(tostring(k))
                this.getCandidateView().setVisibility(0) --显示候选栏
                service.sendEvent("Keyboard_default")
               else
                setBackgroundDrawable(Com_words, Clip_board)
                mphr.add(0, ctext)
                service.loadPhrase()
                JsonUtil.save(file2, mphr)
                task(10, function() relayout(luajava.astable(mphr)) end)
                scroll_lay.fullScroll(ScrollView.FOCUS_UP)

              end
            end
          },
          {
            Button;
            BackgroundDrawable=RadiuButton(ButtonColor, 100),
            text="🗑️";
            layout_width="50dp";
            layout_height="wrap";
            gravity="center";
            textColor=ButtonTextColor;
            layout_margin="5dp";
            -- padding="5dp";
            textSize="15sp";
            singleLine = true,
            AllCaps = false,
            id="card_delete",
            onClick=function(v)
              if 剪贴板 == true then
                removeText(ctext, file, mList)
                table.remove(temp, k)
                relayout(temp)
               else
                removeText(ctext, file2, mphr)
                table.remove(phrase, k)
                relayout(phrase)
              end
            end
          },
          -- myCardView("card_add", "＋添加为常用语", "5dp", 50,
          -- function(v)
          -- if v.getChildAt(0).getText() == "    修改    " then
          -- WindowManagers.clip_board_Window(Managerlayout)
          -- editText.setText(text)
          -- 打开输入法(editText)
          -- edpos.setText(tostring(k))
          -- this.getCandidateView().setVisibility(0) --显示候选栏
          -- service.sendEvent("Keyboard_default")
          -- else
          -- setBackgroundDrawable(Com_words, Clip_board)
          -- mphr.add(0, ctext)
          -- -- service.loadPhrase()
          -- JsonUtil.save(file2, mphr)
          -- relayout(temp)
          -- scroll_lay.fullScroll(ScrollView.FOCUS_UP)

          -- end
          -- end
          -- ),
          -- myCardView("card_delete", "🗑️", "5dp", 100,
          -- function()
          -- if 剪贴板 == true then
          -- removeText(ctext, file, mList)
          -- table.remove(temp, k)
          -- relayout(temp)
          -- else
          -- removeText(ctext, file2, mphr)
          -- table.remove(phrase, k)
          -- relayout(phrase)
          -- end
          -- end
          -- ),
        };
      };
      -- return item

      list.addView(loadlayout(item))

      if 剪贴板 == false then
        card_addText(k)
      end

      local dataadp={}
      tag_adp = LuaAdapter(service, dataadp, {
        TextView;
        textSize="15sp";
        layout_height="wrap";
        layout_width="wrap";
        -- background="#ffD7D8DD",
        BackgroundDrawable=RadiuButton(TagBColor, 20),
        gravity="center";
        padding="5dp";
        id="tag_text",
        -- text=dtext,
        textColor=TagTextColor;
        singleLine = true,
        onClick = function(v)
          service.commitText(v.Text)
        end
      })
      tag_list.setAdapter(tag_adp)
      tag_adp.clear()
      for t in string.gmatch(dtext, "(.-)\n") do
        if t == "" then
         else
          设置高度(textheight,80)
          -- 设置高度(card_one,200)
          tag_adp.add({tag_text=t})
        end
      end
      tag_adp.notifyDataSetChanged()
    end

  end
end

relayout(temp)
--卡片动画
local currentMovingNodeId = nil
function MoveAnimation(v)
  local view = v.getParent()
  if currentMovingNodeId ~= nil and currentMovingNodeId ~= view then
    归位动画(currentMovingNodeId, -500, 10)

    local prevCM1 = currentMovingNodeId.getParent().getChildAt(1)
    prevCM1.setVisibility(8)
  end
  -- 更新当前正在移动的节点
  currentMovingNodeId = view

  local view2 = view.getParent().getChildAt(1)
  local cm1vis = view2.getVisibility()

  if cm1vis == 8 then
    view2.setVisibility(0)
    leftMoveAnimation(view)
    rightMoveAnimation(view2)
   else
    view2.setVisibility(8)
    归位动画(view, -500, 10)
  end
end

--[[

local ClicpBatchSize = 20 --list剪贴板首次刷新数量
local offset = 0
local segmentSize = 100 -- 设置每段的长度，首次加载数量

--提示文本适配器
local function HorizontalListAdapter(str)
  --申明java数组
  local jatable = ArrayList()
  --各种添加
  jatable.add(0,str)
  --转成table
  local ttbable = luajava.astable(jatable)
  local mytable = {}--提示
  for i = offset, math.min(offset + ClicpBatchSize, #ttbable) do
    table.insert(mytable, ttbable[i])
  end
  for i,c in pairs(mytable) do
    local dataadp={}
    local tag_adp = LuaAdapter(service, dataadp, {
      TextView;
      textSize="15sp";
      layout_height="wrap";
      layout_width="wrap";
      gravity="center";
      padding="5dp";
      id="tag_text",
      textColor=TagTextColor;
      singleLine = true,
    })
    tag_adp.clear()
    for a,b in pairs(mytable) do
      local value = extract_info(b)
      if a == i then
        for t in string.gmatch(value, "(.-)\n") do
          if t == "" then
           else
            设置高度(card_one,200)
            table.insert(dataadp, {tag_text={text=t,
                BackgroundDrawable=RadiuButton(TagBColor, 20)},
            })
          end
        end
      end
    end

    tag_adp.notifyDataSetChanged()
    tag_list.setAdapter(tag_adp)
    tag_list.onItemClick = function(l,view,p,i)
      service.commitText(view.Tag.tag_text.Text)
    end
  end
end


--卡片动画
-- local currentMovingNodeNum = nil

-- function MoveAnimation(num)
  -- -- 检查当前节点是否与之前的节点相同
  -- if currentMovingNodeNum ~= nil and currentMovingNodeNum ~= num then
    -- -- 如果不同，则先停止之前节点的动画，并恢复其状态
    -- local prevView = list.getChildAt(currentMovingNodeNum - 1)
    -- local prevCco = prevView.getChildAt(0)
    -- 归位动画(prevCco, -500, 10)

    -- local prevCM1 = prevView.getChildAt(1)
    -- prevCM1.setVisibility(8)
  -- end

  -- -- 更新当前正在移动的节点编号
  -- currentMovingNodeNum = num

  -- local view = list.getChildAt(num - 1)
  -- local cco = view.getChildAt(0)
  -- local cm1 = view.getChildAt(1)
  -- local cm1vis = cm1.getVisibility()

  -- if cm1vis == 8 then
    -- cm1.setVisibility(0)
    -- leftMoveAnimation( cco )
    -- rightMoveAnimation( cm1 )
   -- else
    -- cm1.setVisibility(8)
    -- 归位动画( cco, -500, 10)
  -- end
-- end



local handler_grid = Handler(luajava.new(Handler.Callback,{
  handleMessage=function(meg)
    local num = meg.arg1
    -- local num2 = meg.arg2
    local str = tostring(meg.obj)
    local item = itemView(num, str)
    -- local data={}
    -- table.insert(data, item)
    -- for k, v in ipairs(data) do
    list.addView(loadlayout(item))
   -- end
   
    card_menu.setOnClickListener(function(l)
      MoveAnimation(num)
    end)

    card_add.setOnClickListener(function()
      setBackgroundDrawable(Com_words, Clip_board)
      mphr.add(0, str)
      service.loadPhrase()
      JsonUtil.save(file2, mphr)
      init_words(luajava.astable(mphr))
      scroll_lay.fullScroll(ScrollView.FOCUS_UP)
    end)

    card_delete.setOnClickListener(function()
      removeText(str, file, mList)
      init_cilp_wx(luajava.astable(mList))
    end)
    HorizontalListAdapter(str)
  --  list.requestLayout()
   -- list.invalidate()
   
    if(num == mList.size())
      -- list.requestLayout()
     -- service.loadClipboard()
    end
    return true
  end
}))



-- function processDataBatch(data, currentBatch)
  -- local dataBatch = {}

  -- local startIndex = (currentBatch - 1) * segmentSize + 1
  -- local endIndex = currentBatch * segmentSize
  -- if endIndex > #data then
    -- endIndex = #data
  -- end
  -- for i = startIndex, endIndex do
    -- table.insert(dataBatch, data[i])
  -- end
  -- return dataBatch
-- end

function processDataInThread(dataBatch, handler)
  Thread(Runnable({
    run=function()
      for i, n in pairs(dataBatch) do
        local mess = handler.obtainMessage()
        mess.arg1 = i
        -- mess.arg2 = (currentBatch * segmentSize + i) - segmentSize
        mess.obj = n
        handler.sendMessage(mess)
      end
  end})).start()
end

    
    
function init_cilp_wx(data) --剪贴板刷新
  if #data == 0 then
    print("剪切板为空")
   else
   list.removeAllViews()
    -- currentBatch = 1 -- 初始化批次号
    -- totalBatches = math.ceil(#data / segmentSize)
    -- dataBatch = processDataBatch(data, currentBatch)
    processDataInThread(data, handler_grid) -- 在线程中处理数据批次
  end
end

-- init_cilp_wx(temp)


-- function MyonScroll(data)
  -- list.removeAllViews()
   -- totalBatches = math.ceil(#data / segmentSize)
  -- if currentBatch < totalBatches then
    -- dataBatch = processDataBatch(data, currentBatch)
    -- currentBatch = currentBatch + 1 -- 更新批次号
    -- processDataInThread(dataBatch, handler_grid)
  -- end
-- end

]]

--import "keyboards.ClipBoardWindow"

--
-- local avvr = this.getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE)---获取输入法组件


-- wmManager = service.getApplicationContext().getSystemService(Context.WINDOW_SERVICE)
-- params = WindowManager.LayoutParams()


view_v_0.OnTouchListener=function(v,e)
  local ljpe = e.getActionMasked()
  switch(ljpe)
   case MotionEvent.ACTION_DOWN
   case MotionEvent.ACTION_OUTSIDE
    params.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
    | WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM--输入法焦点
    | WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED--启动硬件加速
    | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED--锁屏界面隐藏
    wmManager.updateViewLayout(Managerlayout,params)
  end
  return false--窗体外触摸
end

local 点击次数=1
view_v_2.onClick=function(e)
  local height = 228 --frame_1.getHeight()
  点击次数 = 点击次数+1
  if 点击次数 % 2 == 1 then
    设置高度(frame_1, height)
  end
  if 点击次数 % 2 == 0 then
    设置高度(frame_1, height*2)
  end
end


--[[
-- local function onTouch(v,event)
      -- print(event)
-- end

-- editText.setOnTouchListener(onTouch)


local handler_words = Handler(luajava.new(Handler.Callback,{
  handleMessage=function(meg)
    local num = meg.arg1
    local num2 = meg.arg2
    local text = tostring(meg.obj)
    local item = itemView(num, text)
    list.addView(loadlayout(item))

    card_menu.setOnClickListener(function()
      MoveAnimation(num)
    end)

    card_add.setOnClickListener(function(v)
      WindowManagers.clip_board_Window(Managerlayout)
      editText.setText(text)
      打开输入法(editText)
      edpos.setText(tostring(num))
      this.getCandidateView().setVisibility(0) --显示候选栏
      service.sendEvent("Keyboard_default")
    end)
    editBC.onClick=function()
      local edText = editText.getText()
      local bnum= edpos.getText()
      mphr.remove(bnum-1)
      mphr.add(0, tostring(edText))
      JsonUtil.save(file2, mphr)
      WindowManagers.closeWindow(Managerlayout)
    end

    card_delete.setOnClickListener(function()
      removeText(text, file2, mphr)
      init_words(luajava.astable(mphr))
    end)

    card_addText(num)
    HorizontalListAdapter(text)

    if(num == mphr.size())
      list.requestLayout()
    end

  end
}))


function init_words(data) --常用语刷新
  if #data == 0 then
    print("常用语为空")
   else
    list.removeAllViews()
    processDataInThread(data, handler_words)
  end
end
]]
import "android.text.Html"
local lineCount = ClipboardSize().lineCount
if lineCount == -1 then
  lineCount = 0
 else
  lineCount = ClipboardSize().lineCount
end

local sizeC = "<font color='#30C190'>剪贴板<br><br></font><font fontSize='10'><i>当前数量：</i></font>"..lineCount.."<br><i>设置数量：</i><b></font><font color='#EE7700'>"..ClipboardSize().getSzie.."</b></font><br><br><font color='#EE7700'>长按清空</b></font>"
sizeC=sizeC:gsub("\n","<br>")

local clip_set_lay={
  LinearLayout;
  layout_width="fill",
  gravity="center";
  layout_height="fill";
  Visibility=8,
  id="clipset",
  {
    TextView;
    BackgroundDrawable=RadiuButton(0xccF7F7F9, 50),
    id="clipsize",
    text=Html.fromHtml(sizeC),
    layout_width="90dp";
    layout_height="180dp";
    layout_margin="10";
    gravity="center";
    textSize="13sp";
  },
  {
    GridLayout;
    layout_width="wrap";
    layout_height="wrap";
    columnCount="3",
    rowCount="2";
    id="grid_layout",
    --
  },
}

local function gridTv(t)
  local view = {
    LinearLayout;
    layout_width="fill",
    gravity="center";
    layout_height="fill";
    {
      TextView;
      BackgroundDrawable=RadiuButton(0xCCF7F7F9, 50),
      id="sizeText",
      text=t;
      layout_width="90dp";
      layout_height="90dp";
      layout_margin="10";
      gravity="center";
      textSize="18sp";
  }}
  return view
end

local function girdTView(clip_set_lay)
  clip_set_view.addView(loadlayout(clip_set_lay))
  local numkh = {"0", "50", "300", "500", "900", "3000"} --剪贴板数量
  local sizeTextList = {}
  for a, b in pairs(numkh) do
    local view = loadlayout(gridTv(b))
    grid_layout.addView(view)
    table.insert(sizeTextList, sizeText)
    local getShData = this.getSharedData("clipboard_size")
    local stext = sizeText.getText()
    sizeText.setTextColor(0xFF2C2B30)
    for i = 1, 6 do
      if a == i and stext == getShData then
        sizeText.setTextColor(0xCEC13000)
        break
      end
    end

    sizeText.setOnClickListener(function(v)
      local text = tostring(v.text)
      for i, textView in ipairs(sizeTextList) do
        if textView == v then
          v.setTextColor(0xCEC13000)
          this.setSharedData("clipboard_size", text)
          Rime.resetSchema()
          this.initKeyboard()--刷新键盘界面并返回到主键盘
          this.loadClipboard()
          JsonUtil.save(file, mList)
          -- service.sendEvent("Deploy")
          os.exit()
          print("设置剪贴板数量："..text.." 条")
         else
          textView.setTextColor(0xFF2C2B30)
        end
      end
    end)
  end
  clipsize.onLongClick=function(v)
    mList.clear()
    table.clear(temp)
    JsonUtil.save(file, mList)
    relayout(temp)
    service.loadClipboard()
    v.setText("已完成清空\n\n剪贴板数量："..mList.size())
    -- v.requestLayout()
    print("已清空剪贴板")
  end
end


--[[
import "android.graphics.Path"
    import "java.nio.file.Path"
    import "android.graphics.Paint"
    import "android.graphics.RectF"
    import "com.androlua.LuaDrawable"

local function toggleTime(view)
  view.background = LuaDrawable(function(c, p, d)
    p.setColor(0xff000000)
    p.setAntiAlias(true)
    local b = d.bounds
    local W = b.right
    local H = b.bottom

    local fontSize = 30
    local textPadding = -10
    p.setTextSize(fontSize)
    p.setTypeface(Typeface.DEFAULT_BOLD)
    p.setTextAlign(Paint.Align.CENTER)
    local currentTime = os.date("%H:%M:%S")
    c.drawColor(0x0030C190)
    c.drawText(currentTime, W / 2, H / 2 - fontSize / 2 - textPadding, p)
    
    local fontSize = 20
    local textPadding = -35
    p.setTextSize(fontSize)
    p.setTypeface(Typeface.DEFAULT_BOLD)
    p.setTextAlign(Paint.Align.CENTER)
    local ymd = os.date("%Y年%m月%d日-星期%w")
    c.drawColor(0x0030C190)
    c.drawText(ymd, W/2 , H/2 - fontSize/3 - textPadding, p)
    
    d.invalidateSelf()
  end)
end
toggleTime(timed)
]]

local function toggleClipSet(clickCont)
  local text = Set_clip.getChildAt(0)
  if clickCont % 2 == 1 then
    clipset.visibility = 8
    scroll_lay.visibility=0
    text.setText("⚙️")
  end
  if clickCont % 2 == 0 then
    girdTView(clip_set_lay)
    -- text.setText("剪贴板设置")
    clipset.visibility = 0
    -- scroll_down.visibility = 8
    scroll_lay.visibility = 8
  end
end
local clickCont = 1
Set_clip.setOnClickListener(View.OnClickListener {
  onClick = function()
    clickCont = clickCont + 1
    toggleClipSet(clickCont)
  end
})

local function continuousKeyPress(view, callback)
  local spaceTask = Ticker()
  spaceTask.Period = 100 -- 时间间隔
  spaceTask.onTick = function()
    if callback then
      callback() -- 执行指定操作
    end
  end
  spaceTask.start()
  local onTouchListener = View.OnTouchListener {
    onTouch = function(v, event)
      if event.getAction() == MotionEvent.ACTION_UP then -- 当松开手指时停止任务
        v.setOnTouchListener(nil) -- 停止触摸监听
        if spaceTask then
          spaceTask.stop()
          spaceTask = nil
        end
      end
      return false
    end
  }
  view.setOnTouchListener(onTouchListener)
end

key_del.onClick=function(view)
  this.onKey(KeyEvent.KEYCODE_DEL, 0)
end
key_del.onLongClick=function(view)
  continuousKeyPress(view,
  function()
    this.onKey(KeyEvent.KEYCODE_DEL, 0)
  end)
end

scroll_down.onClick=function() --向下
  scroll_lay.fullScroll(ScrollView.FOCUS_DOWN)
  -- thread(加载)
end

-- timed.onClick=function() --时间,向下
-- scroll_lay.fullScroll(ScrollView.FOCUS_DOWN)
-- end

Clip_board.onClick=function() --剪贴板
  剪贴板 = true
  setBackgroundDrawable(Clip_board, Com_words)
  relayout(temp)
  scroll_lay.fullScroll(ScrollView.FOCUS_UP)
  toggleClipSet(1)
end
Com_words.onClick=function() --常用语
  剪贴板 = false
  setBackgroundDrawable(Com_words, Clip_board)
  relayout(phrase)
  scroll_lay.fullScroll(ScrollView.FOCUS_UP)
  toggleClipSet(1)
end
-- Com_words.setOnLongClickListener(function(v)
-- WindowManagers.clip_board_Window(Managerlayout)
-- editText.setText(tostring(mphr))
-- 打开输入法(editText)
-- edpos.setText("全部")
-- 设置高度(frame_1,500)
-- this.getCandidateView().setVisibility(0) --显示候选栏
-- service.sendEvent("Keyboard_default")
-- end)

this.getCandidateView().setVisibility(8) --隐藏候选栏
back.onClick=function() --返回
  this.getCandidateView().setVisibility(0) --显示候选栏
  service.sendEvent("Keyboard_default")
  --this.onKey(KeyEvent.KEYCODE_BACK, 0)
  -- service.setKeyboard(Config.get().getKeyboardNames()[0] )
end

function 增加()
  if 剪贴板 == true then
    pabr.incrementProgressBy(10)
    pabr.incrementSecondaryProgressBy(10)
    pabr.visibility = 0
      pabr.visibility = 8
      load50()
      relayout(temp)
      print("加载完成")
  end
end
-- function 加载()
  -- require "import"
  -- for i=1,2 do
    -- Thread.sleep(300)
    -- call("增加",tostring(i))
  -- end
-- end

-- if 剪贴板 == true then
  local x1, x2 = 0, 0
  scroll_lay.setOnScrollChangeListener{
    onScrollChange=function (view, a, b, c)
      local y = scroll_lay.getScrollY()
      if y == 0 then
        --print("到首部了")
      end
      local childView = scroll_lay.getChildAt(0)
      if b > childView.getHeight() - scroll_lay.getHeight() - 20 then
        -- 检测滚动到底部，加载下一段数据
        x2 = os.clock()
        local elapsedSeconds = x2 - x1
        if elapsedSeconds > 3 then
          --print("滑动到底部")
          -- thread(加载)
          增加()
          x1 = os.clock() -- 更新记录时间
        end
      end
  end }
-- end













return layout