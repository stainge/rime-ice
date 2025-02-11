require "import"
import "java.io.*"
import "java.io.File"
import "com.osfans.trime.*" --载入包
import "java.io.*"
import "android.os.*" --系统包
import "android.app.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "android.content.*"
import "android.widget.TextClock"
import "android.widget.EditText"
import "android.graphics.Color"

local 说明 = [[
添加计算器： 长按 7
添加八卦、九字真言： 长按 8
添加生肖、地支： 长按 .
添加节气： 长按 0 --主键盘显示，没啥用
添加大写数字、天干： 长按 ✢
--
震动和按键音与输入法设置同步
计算器模式下：
  返回键： 关闭计算器，其他同理
  删除键： 删除计算器输入框中文本
  左侧符号改为双排计算常用符号,关闭后恢复单排英文符号
]]


local 符号键盘 = "script/lua键盘/符号4.lua"
local 农历文件 = service.getLuaExtDir("lua").. "/农历.lua"
local keyColor = 0xaaF4F4F4 --按键背景
local keyHitiColor = 0xFF47BACD --高亮按键背景
local symColor = 0x99F4F4F4  --符号界面背景
local calculatorColor = 0xFF93BE68 --计算器背景色
local calculatorRadius = 15 --计算器背景圆角

--震动跟随输入法
-- local function ThisVibrate()
  -- import "android.content.Context"
  -- local vibrate = this.getSharedData("key_vibrate")
  -- if vibrate then
    -- this.vibrateEffect()
  -- end
-- end

-- --按键音
-- local function ThisAudio()
  -- import "android.content.Context"
  -- local sound = this.getSharedData("key_sound")
  -- if sound then
    -- this.soundEffect()
  -- end
-- end

--添加中文输入法默认按键音、震动
function soundVibrate() 
  this.soundEffect() --按键音
  this.vibrateEffect() --震动
end

local function doFileSymbols()
-- dofile(tostring(service.getLuaExtDir("script")).."/lua键盘/符号4.lua")
  local path = File(Config.get().getSharedDataDir(), 符号键盘)
  if path.exists() then
    local filelua = path.getAbsolutePath()
    local trimeService = Trime.getService()
    trimeService.doFile(filelua)
   else
   print("没有符号键盘脚本！")
  end
end

import "android.graphics.drawable.GradientDrawable"
local function RadiuButton(color, radius)
  local shape = GradientDrawable()
  shape.setShape(GradientDrawable.RECTANGLE)
  shape.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  shape.setColor(color)
  return shape
end

local height = "586"
pcall(function()
  local height = service.getLastKeyboardHeight()
end)
local width = service.getWidth()

local layout = {
  LinearLayout;
  layout_height="fill";
  gravity="center";
  layout_width="fill";

  {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    gravity="center";
    layout_margin="5dp";
    orientation="horizontal";
    -- background="#66FF99FF";
    {
      LinearLayout;
      layout_height="fill";
      layout_width=width/5;
      layout_margin="2dp";
      layout_marginTop="2dp";
      layout_marginBottom="6dp";
      BackgroundDrawable=RadiuButton(symColor, 20),
      {
        GridView;
        layout_height="fill";
        id="sym_grid";
        layout_width="fill";
        VerticalScrollBarEnabled=false,
        -- fastScrollEnabled=true,
        numColumns=1, 
      };
    };
    {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      gravity="center";
      layout_gravity="center",
      {
        GridLayout;
        columnCount="4";
        layout_width="fill";
        layout_height="fill";
        rowCount="4";
        id="num_grid";
      };
    };
    -- {
    -- LinearLayout;
    -- layout_height="fill";
    -- id="num_gn";
    -- layout_width=width/4;

    -- };
  };
};

local numlayout = loadlayout(layout)

function check_function_existence()
    local function_name = "solar2LunarByTime" --农历函数名
    local file = io.open(农历文件, "r")
    if not file then
        print("无法打开文件： " .. 农历文件)
        return false
    end

    local content = file:read("*all")
    file:close()

    local function_pattern = string.format("function %s", function_name)
    if string.find(content, function_pattern) then
        -- print("函数 " .. function_name .. " 存在于文件 " .. 农历文件 .. " 中")
        return true
    else
        print("函数 " .. function_name .. " 不存在于文件 " .. 农历文件 .. " 中")
        return false
    end
end
local function 农历显示()
  local status, lunar_module = pcall(require, "lua/农历")
  if status then
    -- 模块加载成功
    local now= solar2LunarByTime(os.time())
    lunarDate_1 =tostring( now.lunarDate_4)
   else
    -- 模块加载失败
    lunarDate_1 = Function.getDate("zh_CN@calendar=chinese")
  end
  return lunarDate_1
end

local isLayoutAdded = false --添加布局是否 true添加布局
local function addLayout() --添加计算器布局 
  -- if check_function_existence() then
    -- require("lua/农历")
    -- local now= solar2LunarByTime(os.time())
    -- local lunarDate_1 = now.lunarDate_1
    -- timeText = lunarDate_1..' EEEE yyyy.MM.dd HH:mm:ss'
  -- else
    -- timeText = 'yyyy.MM.dd EEEE HH:mm:ss'
  -- end
  local timeText = 农历显示()..' EE yyyy.MM.dd HH:mm:ss'
  local calculatorLayout = {
  LinearLayout;
  layout_height="wrap";
  layout_width="fill";
  orientation=1;
  -- Visibility=8,
  {
    TextClock;
    textSize="15sp";
    textColor="#ff000000";
    paddingTop="5dp";
    -- BackgroundColor="#ff000000";
    gravity="center";
    layout_width="fill",
    -- layout_weight="1";
    layout_height="wrap",
    Format24Hour=timeText;
    onClick=function(v)
      local tet = v.getText()
      local time = string.gsub(tet, "[%s\t\n]+", "\n")
      service.commitText(time)
    end
  },
  {
  LinearLayout;
  layout_height="wrap";
  layout_width="fill";
  layout_marginLeft="20dp";
    -- layout_marginRight="20dp";
  orientation=0;
  {
    TextView;
    id="input";
    layout_width=this.getWidth()/2,
    layout_height="wrap";
    -- MinimumHeight="45dp",
    -- gravity="center";
    textColor="#ff000000";
    textSize="22sp";
    -- singleLine=true;
    -- BackgroundColor="#FF93BE68";
    BackgroundDrawable=RadiuButton(calculatorColor, calculatorRadius);
     onClick="edClick",
  };
  {
    TextView;
    id="reText";
    layout_width="fill";
    layout_weight="1",
    layout_height="wrap";
    -- MinimumHeight="45dp",
    layout_marginLeft="20dp";
    layout_marginRight="20dp";
    gravity="center";
    textColor="#ff000000";
    textSize="22sp";
    -- singleLine=true;
    -- BackgroundColor="#FF93BE68";
    BackgroundDrawable=RadiuButton(calculatorColor, calculatorRadius);
    onClick="edClick",
  };
  {
    TextView;
    -- id="reText";
    layout_width="wrap";
    layout_height="wrap";
    -- MinimumHeight="45dp",
    -- layout_marginLeft="20dp";
    layout_marginRight="20dp";
    gravity="center";
    textColor="#ff000000";
    textSize="22sp";
    text="᪣",
    singleLine=true;
    onClick=function(v)
    print("其他功能，未制作")
    end
    -- BackgroundColor="#FF93BE68";
    -- BackgroundDrawable=RadiuButton(calculatorColor, calculatorRadius);
    -- onClick="edClick",
  };
};
}
  local calculatorLayout = loadlayout(calculatorLayout)
  local view2 = this.getCandidateContainer()
  view2.setOrientation(1)
  view2.addView(calculatorLayout,0)
  isLayoutAdded = true 
  local view3=view2.getChildCount()
  if view3 > 2 then
    view2.removeView(view2.getChildAt(0))
    isLayoutAdded = false
  end
  function edClick(v)
   if  tonumber(v.Text) then
    service.commitText(v.Text)
   else
   local result = calculator(tostring(input.getText().toString()))
    service.commitText(v.Text.."="..result)
   end
  end
  -- local key=service.getKeyboardView()
  -- local keys = key.getKeyboard().getKeys()
  -- local Text = keys[1].getClick().getRawText()
  -- edit.append(tostring(Text))
end

local function Hide() --移除计算器布局
local view2 = this.getCandidateContainer()
   view2.removeView(view2.getChildAt(0))
    isLayoutAdded = false
end

--local numGrid

local function numBotton(a)
  numList= {
    LinearLayout;
    layout_width=width/5-10;
    layout_height=height/4-10;
    {
      Button;
      BackgroundDrawable=RadiuButton(keyColor, 20),
      text=a;
      layout_width="fill";
      layout_height="fill";
      gravity="center";
      -- layout_gravity="center";
      layout_margin="2dp";
      padding="5dp";
      textSize="18sp";
      singleLine = true,
      AllCaps = false,
      id="botton",
    },
  }
  --table.insert(numGrid, numList)
  return numList
end

local function setBackgroundDrawable(view)
  view.setBackgroundDrawable(RadiuButton(keyHitiColor, 20))
  task(200, function()
    view.setBackgroundDrawable(RadiuButton(keyColor, 20))
  end)
end


local num_table={"1","2","3","➥","4","5","6","␣","7","8","9","⌫","✢","0",".","⏎"}

local calculatorData = {"1","2","3","关闭","4","5","6","=","7","8","9","⌫","%","0",".","清空"}

local chi_table={'壹','贰','叁','返回','肆','伍','陆','␣','柒','捌','玖','⌫','✢','零',"拾","⏎"}

local numfh_table={"+","-","*","/",",","=","%","@","(",")","[","]","{","}","<",">","\\","?",
  ":",";","'",'"',"!","`","^","~","_","﹉","–","€","|","·","&","#","$","√", "π"
}
--运算符号
local math_symbols = {'＋', '－', '×', '÷', '^', '√',  '(', ')', 'π', 'e', "cos(", "tan(", "sin("}

local chineseZodiac = {
  "鼠", "牛", "虎", "返回", "兔", "龙", "蛇", "␣", "马", "羊", "猴", "⌫", "鸡", "狗", "猪", "⏎"
}
local earthlyBranches = {
  "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"
}
local heavenlyStems = {
  "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"
}
local bagua = {
  "乾", "坤", "震", "巽", "坎", "离", "艮", "兑"
}
local nineWords = {
  "临", -- 象征：身心稳定；表示：临事不动容，保持不动不惑的意志，表现坚强的体魄。结合天地灵力，降魔除妖大威力。
  "兵", -- 象征：能量；表示延寿和返童的生命力。
  "斗", -- 表示战斗、对抗的力量。
  "返回",
  "者", -- 表示胜利的决心。
  "皆", -- 表示全体团结一致。
  "阵", -- 表示布阵、排兵的能力。
  "␣",
  "列", -- 表示排列有序、井然有序的状态。
  "在", -- 表示存在、实在的意义。
  "前", -- 表示前进、积极向前的态度。
  "⌫","✢","0",".","⏎"
}
--修改主键盘(default)显示
local solarTerms = {
  "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
  "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
  "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
  "立冬", "小雪", "大雪", "冬至", "小寒", "大寒",
  "Keyboard_default"
}
local function setKeyboard_solar()
  local def = Config.get().getKeyboardNames()[0]
  local Kboard = Config.get().getKeyboard(def)
  local Bkeys = luajava.astable(Kboard.keys)
  local data = {}
  for i = 1, #Bkeys do
    if string.match(tostring(Bkeys[i].click), "^[%a]$") then
      gg=tostring(i)
    end
    if Bkeys[i].click == nil or Bkeys[i].click == "" then
      kk=tostring(i)
    end
  end

  for i = 1, 10 do
    if string.match(tostring(Bkeys[i].click), "^[%a]$") then
      Bkeys[i].click = solarTerms[i]
    end
  end

  for i = 12, kk do
    if string.match(tostring(Bkeys[i].click), "^[%a]$") then
      Bkeys[i].click = solarTerms[i-1]
    end
  end

  for i = 22, gg do
    if string.match(tostring(Bkeys[i].click), "^[%a]$") then
      Bkeys[i].click = solarTerms[i-3]
    end
  end

  service.setKeyboard(Kboard)
end

local function gsub(expression, a, b)
    return expression:gsub(a, b)
end

--计算
 function calculator(expression)
  -- 处理根号、百分号、π、sin、cos、tan输入
  local expression = gsub(expression, "π", "math.pi")
  local expression = expression:gsub("√(%d+)", "math.sqrt(%1)")
  local expression = expression:gsub("%%", "/100")
  local expression = expression:gsub("sin%((.-)%)", "math.sin(%1)")
  local expression = expression:gsub("cos%((.-)%)", "math.cos(%1)")
  local expression = expression:gsub("tan%((.-)%)", "math.tan(%1)")
  local expression = expression:gsub("e", "math.exp(1)")
  local expression = expression:gsub("＋", "+")
  local expression = expression:gsub("－", "-")
  local expression = expression:gsub("×", "*")
  local expression = expression:gsub("÷", "/")
  local ok, func = pcall(loadstring("return " .. expression))
  if ok then
    local result = tostring(func)
    -- reText.append("="..result)
    return result
   else
    -- reText.append("错误")
    return func
  end
end

function Oitemclick(t)
  if isLayoutAdded then
  -- local view2 = this.getCandidateContainer()
  -- local input = view2.getChildAt(0).getChildAt(1).getChildAt(0)
    if t == "@" then
      input.setText("")-- 清空文本
     elseif t == "=" then
      local result = calculator(tostring(input.getText().toString()))
      reText.setText(result)
     else
      input.append(t)
    end
   else
    this.commitText(t)
  end
end

function Oclick(v)
  if isLayoutAdded then
    if v == "=" then
      local result = calculator(tostring(input.getText().toString()))
      reText.setText(result)
     elseif v == "清空" then
      input.setText("")
      reText.setText("")
     else
      input.append(v)
    end
       else
        this.commitText(v)
  end
end

local function numGrid(t)
  local data={}
  table.clear(data)
  for k, v in ipairs(t) do
    table.insert(data, v)
  end
  num_grid.removeAllViews()

  for k, v in ipairs(data) do
    numList = numBotton(v)
    num_grid.addView(loadlayout(numList))
    botton.onClick=function(a)
      if not (v=="➥" or v=="␣" or v=="⌫" or v=="␣" or v=="⏎" or v=="✢" or v=="." or v=="返回" or v=="关闭") then
        Oclick(v)
       else
        if v == "➥" then
          -- if not isLayoutAdded then
            service.sendEvent("Keyboard_default") --返回主键盘
           -- else
           -- HideCalculator()
          -- end
         elseif v == "关闭" then
          HideCalculator()
         elseif v == "返回" then
          fresh(numfh_table)
          numGrid(num_table)
         elseif v == "␣" then
          this.onKey(KeyEvent.KEYCODE_SPACE, 0)--模拟空格键
         elseif v == "⌫" then
          if not isLayoutAdded then
            this.onKey(KeyEvent.KEYCODE_DEL, 0)--模拟删除键
           else
            local new_str = utf8.sub(input.getText().toString(), 1, -2)
            input.setText(tostring(new_str))
          end
         elseif v == "⏎" then
          this.onKey(KeyEvent.KEYCODE_ENTER, 0)--模拟回车键
         elseif v == "✢" then
          doFileSymbols()
         elseif v == "." or v=="拾" then
          Oclick(v)
        end
      end
      soundVibrate()
      setBackgroundDrawable(a)
    end

    botton.onLongClick=function(a)
      if v == "✢" then
        numGrid(chi_table)
        fresh(heavenlyStems)
       elseif v == "." or v=="拾" then
        numGrid(chineseZodiac)
        fresh(earthlyBranches)
       elseif v == "8" or v=="捌" then
        numGrid(nineWords)
        fresh(bagua)
       elseif v == "0" or v=="零" then
        setKeyboard_solar()
       elseif v == "7" then
        if isLayoutAdded then
          HideCalculator()
         else
        addLayout()
        numGrid(calculatorData)
        sym_grid.setNumColumns(2)
        fresh(math_symbols)
        end
      end
      return true
    end
   
   if v == "关闭" then
    botton.setTextColor(0xffff0000)
    else
    -- 
   end

  end
  num_grid.invalidate()
end

numGrid(num_table)

function HideCalculator() --关闭计算器
     Hide()
    numGrid(num_table)
    fresh(numfh_table)
    sym_grid.setNumColumns(1)
end

if isLayoutAdded  then --如果进入其他界面，再次进入数字键盘自动关闭计算器
else
 local view2 = this.getCandidateContainer()
 if view2.getChildCount() > 1 then
  Hide()
  end
end

local item=
{
  LinearLayout;
  layout_height="55dp";
  layout_width="fill";
  orientation="vertical";
  gravity="center";
  id="fhkey";
  {
    TextView;
    textSize="22sp";
    text="符号";
    id="fhtext";
    layout_height="60dp";
    layout_width="fill";
    gravity="center";
    layout_gravity="center";
    textColor="#FF141414";
  };
};

function fresh(t)
  local data={}
  local adp=LuaAdapter(service,data,item)
  table.clear(data)
  for _,v in ipairs(t) do
    table.insert(data,{fhtext= v})
  end
  adp.notifyDataSetChanged()
  sym_grid.setSelection(0)
  sym_grid.setAdapter(adp)
end



fresh(numfh_table)

sym_grid.onItemClick=function(l, v, p, i)
  local t = v.Tag.fhtext.Text
  Oitemclick(t)
  soundVibrate()
end

--
return numlayout

