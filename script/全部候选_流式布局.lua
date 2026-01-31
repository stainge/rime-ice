--[[
脚本使用说明
放置 中文输入法目录/keyboards 路径下即可
自动替换输入法候选布局,点击候选栏最右边倒三角按钮显示

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

local 输入法目录=tostring(service.getLuaExtDir(""))
local 脚本目录=输入法目录.."/script"
local 字体目录=输入法目录.."/fonts"
local 字体,字体存在=字体目录.."/流式布局.ttf",false
local 字体_1 
if File(字体).exists() then
  字体_1 = Typeface.createFromFile(字体)
  字体存在=true
end
 

local 候选组=Rime.getCandidates()
local 编码=Rime.RimeGetInput() --當前編碼
if 编码=="" or 编码==nil then
  service.sendEvent("Keyboard_default")
  return
end


local 显示内容组,提示内容组={},{}

local function 更新内容组()
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

local function 候选翻页(上翻否)--默认下翻,无参数
  if 上翻否~=true then
    if Rime.hasRight()==false then  --当前候选栏可左翻否
     print("已经是最后面了")
     return
    end
    service.onKey(KeyEvent.KEYCODE_PAGE_DOWN, 0)
  else
    if Rime.hasLeft()==false then  --当前候选栏可左翻否
     print("已经是最开始了")
     return
    end
    service.onKey(KeyEvent.KEYCODE_PAGE_UP, 0)
  end
  Key.presetKeys.lua_script_l={label= "脚本", send="function", command="全部候选_流式布局.lua", option=""}
  service.sendEvent("lua_script_l")
end

import "android.graphics.RectF"
import "android.graphics.drawable.StateListDrawable"
local function Back() --生成功能键背景
  local bka=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0x49ffffff)
    c.drawRoundRect(b,20,20,p) --圆角20
  end)
  local bkb=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0x49d3d7da)
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

local layout1={
  LinearLayout;
  orientation="vertical";
  layout_width="fill";
  layout_height="fill";
  background="#FFFFFFFF";
  {
    LinearLayout;
    --layout_width="fill";
    --layout_height="fill";
    --verticalScrollBarEnabled=false;
    {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      
            {
        LinearLayout;
        layout_width="fill";
        orientation="vertical";
        background="#ffffffff";
        layout_height="fill";

   {
    ScrollView;
    layout_height=height-120;
    layout_width=width;
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
      }, 
      

      {
        LinearLayout;
        layout_width="fill";
        orientation="vertical";
        background="#ffffffff";
        layout_height="80dp";
        {
          LinearLayout;
          layout_width="fill";
          gravity="center";
          orientation="horizontal";
          background="#ffffffff";
          padding="10dp";
         {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            layout_marginLeft="10dp";
            textSize="15sp";
            text="  上一页  ";
            onClick=function() 候选翻页( true) end
          };
           {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            layout_marginLeft="10dp";
            textSize="15sp";
            text="  下一页  ";
            onClick=function() 候选翻页()  end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            layout_marginLeft="10dp";
            textSize="15sp";
            text="  ⏎  ";
            onClick=function() service.sendEvent("Return") end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            layout_marginLeft="10dp";
            textSize="15sp";
            text="  ⌫  ";
            onClick=function()
             service.sendEvent("BackSpace")
             Key.presetKeys.lua_script_l={label= "脚本", send="function", command="全部候选_流式布局.lua", option=""}
             service.sendEvent("lua_script_l")

             end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            layout_marginLeft="10dp";
            textSize="15sp";
            text="  返回  ";
            onClick=function()  service.sendEvent("Keyboard_default") end
          };
        };
      };
 
      };

    }
  }
}


local layout={
  LinearLayout;
  orientation="vertical";
  layout_width="fill";
  layout_height="fill";
  background="#FFFFFFFF";
  {
    LinearLayout;
    --layout_width="fill";
    --layout_height="fill";
    --verticalScrollBarEnabled=false;
    {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      
            {
        LinearLayout;
        layout_width="fill";
        orientation="vertical";
        background="#ffffffff";
        layout_height="fill";

   {
    ScrollView;
    layout_height=height-120;
    layout_width=width;
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
      }, 
      

      {
        LinearLayout;
        layout_width="fill";
        orientation="vertical";
        background="#ffffffff";
        layout_height="80dp";
        {
          LinearLayout;
          layout_width="fill";
          gravity="center";
          orientation="horizontal";
          background="#ffffffff";
          padding="4dp";
         {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
            layout_marginLeft="10dp";
            textSize="20sp";
            text=" 上一页 ";
            onClick=function() 候选翻页( true) end
          };
           {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
            layout_marginLeft="10dp";
            textSize="20sp";
            text=" 下一页 ";
            onClick=function() 候选翻页()  end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
            layout_marginLeft="10dp";
            textSize="20sp";
            text="  ⏎  ";
            onClick=function() service.sendEvent("Return") end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
            layout_marginLeft="10dp";
            textSize="20sp";
            text="  ⌫  ";
            onClick=function()
             service.sendEvent("BackSpace")
             Key.presetKeys.lua_script_l={label= "脚本", send="function", command="全部候选_流式布局.lua", option=""}
             service.sendEvent("lua_script_l")

             end
          };
          {
            TextView;
            Typeface=Typeface.DEFAULT_BOLD;
            textColor="#FFE84033";
            Background=Back(),
            layout_marginLeft="10dp";
            textSize="20sp";
            text="  返回  ";
            onClick=function()  service.sendEvent("Keyboard_default") end
          };
        };
      };
 
      };

    }
  }
}
--service.setContentView(loadlayout(layout))
layout=loadlayout(layout)

--一个封装好的流式布局
--Github:https://github.com/nex3z/FlowLayout.git



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
   for i=1,#提示内容组 do
     local a,b=显示内容组[i],提示内容组[i]
     a=a:gsub("<","&lt;")
     a=a:gsub(">","&gt;")
     b=b:gsub("<","&lt;")
     b=b:gsub(">","&gt;")
     local v="<big>"..a.."</big><font color=\'blue\'><b>"..b.."</b></font>"

     v=v:gsub("\n","<br>")
     c={
       LinearLayout;
       --layout_width="-2";
      --layout_height="40dp";
       id="背景";
   
       BackgroundDrawable=CircleButton(0xfff5f5f5,90);
       {
         TextView;
         textColor="0xFF000000";
         padding="8dp";
         layout_marginLeft="2dp";
         layout_marginRight="2dp";
         layout_width="-1";
         gravity="center";
         layout_height="-2";
         textSize="12sp";
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
   
       BackgroundDrawable=CircleButton(0xfff5f5f5,90);
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
   end
end
更新布局()


if 键盘否 then
  键盘否=false
  return layout
end

service.setKeyboard(layout)



