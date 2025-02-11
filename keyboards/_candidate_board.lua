--[[
作者： 风之漫舞
脚本使用说明
放置 中文输入法目录/keyboards 路径下即可
自动替换输入法候选布局,点击候选栏最右边倒三角按钮显示
--
修改功能键布局
]]

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.text.Html"
import "android.graphics.Typeface"
import "java.io.File"--导入File类

import "script/dex/flowlayout:com.nex3z.flowlayout.FlowLayout"

import "com.osfans.trime.*" --载入包

local 显示候选编号= true --显示true,不显示false

local 输入法目录=tostring(service.getLuaExtDir(""))
local 脚本目录=输入法目录.."/script"
local 字体目录=输入法目录.."/fonts"
local 字体,字体存在=字体目录.."/仓耳今楷.ttf",false

local 字体_1 
if File(字体).exists() then
  字体_1 = Typeface.createFromFile(字体)
  字体存在=true
  else
  print("字体不存在")
end
 


local 候选数,编码=0,Rime.RimeGetInput() --當前編碼
if 编码=="" or 编码==nil then
  service.sendEvent("Keyboard_default")
  return
end

local 候选组
local 显示内容组,提示内容组={},{}

local function 更新内容组()
   候选组=Rime.getCandidates()
   if #候选组>0 and 编码!="" and 编码!=nil then
     显示内容组,提示内容组={},{}
    for i=1,#候选组 do
     显示内容组[#显示内容组+1]=tostring(候选组[i-1].text)
     提示内容组[#提示内容组+1]=tostring(候选组[i-1].comment)
     if 候选组[i-1].comment==nil then
       提示内容组[#提示内容组]=""
     end
    end--for
   end
end
更新内容组()




import "android.graphics.RectF"
import "android.graphics.drawable.StateListDrawable"
local function Back() --生成功能键背景
  local bka=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0xFF96B2CE)
    c.drawRoundRect(b,20,20,p) --圆角20
  end)
  local bkb=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0xFFE7E8EC)
    c.drawRoundRect(b,20,20,p)
  end)

  local stb=StateListDrawable()
  stb.addState({-android.R.attr.state_pressed},bkb)
  stb.addState({android.R.attr.state_pressed},bka)
  return stb
end


local height="240dp" --键盘高度
pcall(function()
  --键盘自适应高度，旧版中文不支持，放pcall里防报错
  height=service.getLastKeyboardHeight()
end)
local width=service.getWidth()--取键盘宽度


local layout={
  LinearLayout;
  orientation="horizontal";
  layout_height=height;
  {
    LinearLayout;
    layout_height="fill";
    layout_width=width-200;
    {
      LinearLayout;
      layout_height="fill";
      orientation="vertical";
      layout_width="fill";
      {
        TextView;
        Typeface=Typeface.DEFAULT_BOLD;
        textColor="#FFE84033";
        Background=Back(),
        layout_margin="2dp";
        textSize="20sp";
        text=" 候选数 ";
        id="cand0";
      };
      {
        LinearLayout;
        {
          ScrollView;
          layout_height="fill";
          layout_width="fill";
          --verticalScrollBarEnabled=false;
          id="sco",
          {
            FlowLayout,
            layout_width="fill",
            layout_height="fill",
            -- paddingBottom="30dp";
            --MaxRows="40dp";
            layout_marginLeft="3dp";
            layout_marginBottom="10dp";
            MinChildSpacing="5dp";
            --自控力间距
            ChildSpacing="10dp",
            --行间距
            RowSpacing="10dp",
            id="f2",
          },
        };
      };
    };
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_height="fill";
    gravity="center";
    orientation=1;
    id="keypad";
  };
};




-- local layout={
  -- LinearLayout;
  -- orientation=0;
  -- layout_width="fill";
  -- layout_height="fill";
 -- -- background="#FFFFFFFF";
    
    -- {
      -- LinearLayout;
      -- orientation="vertical";
      -- layout_width=width;
      -- layout_height="fill";
          -- {
      -- LinearLayout;
      -- orientation="vertical";
      -- background="#ffffffff";
      -- layout_width=width-200;
      -- layout_height="wrap";
                 -- {
            -- TextView;
            -- Typeface=Typeface.DEFAULT_BOLD;
            -- textColor="#FFE84033";
            -- Background=Back(),
            
          -- --  layout_marginLeft="10dp";
            -- textSize="12sp";
            -- text=" 候选数 ";
            -- id="cand0";
          -- };
            -- {
        -- LinearLayout;
        -- layout_width="fill";
        -- orientation=0;
        -- --background="#ffffffff";
        -- layout_height="fill";

   -- {
    -- ScrollView;
    -- layout_height=height;
  -- --  layout_width=width-200;
    -- verticalScrollBarEnabled=false;
    -- id="sco",
        -- {
          -- FlowLayout,
          -- layout_width="fill",
          -- layout_height="fill",
          -- -- paddingBottom="30dp";
          -- --MaxRows="40dp";
          -- layout_marginLeft="3dp";
          -- layout_marginBottom="10dp";
          -- MinChildSpacing="5dp";
          -- --自控力间距
          -- ChildSpacing="10dp",
          -- --行间距
          -- RowSpacing="10dp",
          -- id="f2",
        -- },
      -- }, 
      
        -- };
      -- };
 
      -- };

      -- {
        -- LinearLayout;
        -- layout_width=200;
        -- orientation="vertical";
       -- -- background="#ffffffff";
        -- layout_height="fill";
        -- {
          -- LinearLayout;
          -- layout_width="fill";
          -- layout_height="fill";
          -- gravity="center";
          -- orientation=1;
          -- id="keypad";
        --  padding="10dp";

        --[[   {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
         --   layout_marginLeft="15dp";
            textSize="23sp";
            text=" 翻页 ";
            id="next0";
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
          --  layout_marginLeft="15dp";
            textSize="23sp";
            text="  ⏎  ";
            onClick=function() service.sendEvent("Return") end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
           -- layout_marginLeft="15dp";
            textSize="23sp";
            text="  ⌫  ";
            onClick=function()
             local 编码1=Rime.RimeGetInput()
             service.sendEvent("BackSpace")
             if #编码1==1 then
               service.sendEvent("Keyboard_default")
             else
               service.setKeyboard("_candidate_board") --跳转到指定键盘
              end
             end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
         --   layout_marginLeft="15dp";
            textSize="23sp";
            text="  返回  ";
            onClick=function()  service.sendEvent("Keyboard_default") end
          };]]
-- };
    -- }}
 
--service.setContentView(loadlayout(layout))

layout=loadlayout(layout)


--滑动条
import "android.graphics.drawable.ColorDrawable"
sco.setVerticalScrollbarThumbDrawable(ColorDrawable(0xFF46B9FF))

--一个封装好的流式布局
--Github:https://github.com/nex3z/FlowLayout.git

local function addWordToDict(display, prompt)
  local script_path = debug.getinfo(1,"S").source:sub(2)
  local script_dir = script_path:match("^.*/")
  local dict_file = script_dir .. "xhyx.dict.txt"
  local code = display .. "\t" .. prompt .. "\n"
  -- 检查文件是否存在，如果不存在则创建文件
  if not File(dict_file).exists() then
    -- File(dict_file):open("w"):close() -- 创建新文件
  io.open(dict_file, "w"):close()
  end
  io.open(dict_file,"a"):write(code):close()
  print("保存词库")
end

local function CircleButton(InsideColor,radiu)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  return drawable
  --view.setBackgroundDrawable(drawable)
end

local function 更新布局()
--for k,v in pairs(提示内容组) do
   local 编号,v=0,""
   for i=1,#提示内容组 do
     编号=候选数+i
     local a,b=显示内容组[i],提示内容组[i]
     a=a:gsub("<","&lt;")
     a=a:gsub(">","&gt;")
     b=b:gsub("<","&lt;")
     b=b:gsub(">","&gt;")
     if 显示候选编号  then
       v="<font color=\'#EE7700\'>"..编号..".</font><big>"..a.."  ".."</big><font color=\'blue\'><b>"..b.."</b></font>"
     else
       v="<big>"..a.."  ".."</big><font color=\'blue\'><b>"..b.."</b></font>"
     end
     v=v:gsub("\n","<br>")
     c={
       LinearLayout;
       --layout_width="-2";
      --layout_height="40dp";
       id="背景";
   
       BackgroundDrawable=CircleButton(0xe0f5f5f5,20);
       {
         TextView;
         textColor="0xFF000000";
         padding="8dp";
         layout_marginLeft="2dp";
         layout_marginRight="2dp";
         layout_width="-1";
         gravity="center";
         layout_height="-2";
         textSize="16sp";
         Text=Html.fromHtml(v);
         onClick=function()
          service.commitText(显示内容组[i]) 
          service.sendEvent("Keyboard_default")
          service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)
       end
       };
     };
     if 字体存在 then --使用指定字体显示内容
       c={
       LinearLayout;
       --layout_width="-2";
      --layout_height="40dp";
       id="背景";
   
       BackgroundDrawable=CircleButton(0xfff5f5f5,20);
       {
         TextView;
         textColor="0xFF000000";
         Typeface=字体_1,
         padding="8dp";
         layout_marginLeft="1dp";
         layout_marginRight="1dp";
         layout_width="-1";
         gravity="center";
         layout_height="-1";
         textSize="12sp";
         Text=Html.fromHtml(v);
         onClick=function()
          service.commitText(显示内容组[i]) 
          service.sendEvent("Keyboard_default")
          service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)
       end
       };
     };
    end
     
     
     f2.addView(loadlayout(c))
     -- md按钮(md,20,0x7ab946ff,0xDab946ff)
     -- addWordToDict(a,b)
   end--for
   候选数=候选数+#提示内容组
   cand0.setText(" 候选数:"..候选数.." ")
end
更新内容组()
更新布局()

local function 自动翻页()--默认下翻,无参数
    if Rime.hasRight()==false then  --当前候选栏可左翻否
     print("候选已经全部显示了")
    else
      service.onKey(KeyEvent.KEYCODE_PAGE_DOWN, 0)
      更新内容组()
      更新布局()
      sco.fullScroll(ScrollView.FOCUS_DOWN)
    end
end


--功能键
local function gnButtons(parentView)
    -- 连续输出事件 
    local function continuousKeyPress(view, callback)
        local spaceTask = Ticker()
        spaceTask.Period = 100 -- 时间间隔
        spaceTask.onTick = function()
            if callback then
                callback() -- 执行指定操作
            end
            view.BackgroundDrawable = Back()
        end
        -- 启动 Ticker 定时器
        spaceTask.start()

        local onTouchListener = View.OnTouchListener {
            onTouch = function(v, event)
                if event.getAction() == MotionEvent.ACTION_UP then -- 当松开手指时停止任务
                    view.BackgroundDrawable = Back()
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

    -- 功能键
    local gn_table = {'➥', '⌫', '翻页', '√'}

    -- 创建功能键按钮
    local function gnButtons(view)
        for c, d in ipairs(gn_table) do
            local button = Button(service)
            button.setText(d)
            button.setBackgroundDrawable(Back())

            local layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            )
            layoutParams.setMargins(5, 0, 5, 20)  --边距顺序 左、上、右、下。

            button.setLayoutParams(layoutParams)
            view.addView(button)

            -- 设置点击事件
            clickCount = 0
            button.onClick = function(v)
            clickCount = clickCount + 1
                if d == "➥" then
-- local jmpj = tostring(this.getLuaExtDir("script")) .. "/lua_keyboard/keyboard.lua"
-- local jm = tostring(this.getLuaExtDir("keyboards")) .. "/.default.lua"
-- if File(jm).exists()==false then
service.sendEvent("Keyboard_default")
-- else
-- dofile(jmpj)
-- end
                   -- service.sendEvent("Keyboard_default") --返回主键盘
                -- elseif d == "␣" then
                    -- this.onKey(KeyEvent.KEYCODE_SPACE, 0)--模拟空格键
                elseif d == "⌫" then
                    this.onKey(KeyEvent.KEYCODE_DEL, 0)--模拟删除键
                elseif d == "翻页" then
                   自动翻页()
                   if Rime.hasRight()==true then 
                   v.setText( "翻页".. clickCount)
                   end
                elseif d == "√" then
                    this.onKey(KeyEvent.KEYCODE_ENTER, 0)--模拟回车键
                
                end
            end

            -- 设置长按事件
            button.onLongClick = function(s)
                -- if d == "␣" then
                    -- continuousKeyPress(s, function()
                        -- this.onKey(KeyEvent.KEYCODE_SPACE, 0)
                    -- end)
                  if d == "⌫" then
                    continuousKeyPress(s, function()
                        this.onKey(KeyEvent.KEYCODE_DEL, 0)
                    end)
                end
                return true
            end
        end
    end
    -- 创建功能键按钮
    gnButtons(parentView)

end

gnButtons(keypad)



local x1,x2,x3= 0,0,0
function sco.onTouch(a,esv)
  x3 = os.clock()
  local 间隔时间1=(x3-x1)*10000
  if 间隔时间1>2 x1=x3 end
  local y=sco.getScrollY()
  if y == 0 then
   --print("到首部了")
  end
  local childView = sco.getChildAt(0)
  if y > childView.getHeight()-sco.getHeight()-10 then
    x2 = os.clock()
    local 间隔时间=(x2-x1)*10000
    if 间隔时间>6 then
      --print("滑动到底部") 
      自动翻页()
    end
  end
end





return layout






