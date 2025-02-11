--[[
自定义剪切板5.0.6
▂▂▂▂▂▂▂▂
当前版本: V5.0.6
更新日期: 2022-09-10
更新作者: 小浩 3489472862
更新内容: 
         1. 添加剪切板手动清理功能
         2. 修复广播会重复添加的bug
         3. 使用的自动状态栏为1.5版本
         4. 优化依赖脚本判断
         5. 优化标题上剪切板数量的显示
         6. 修改返回主键盘的方法


自定义剪切板5.0.5
▂▂▂▂▂▂▂▂
当前版本: V5.0.5
更新日期: 2022-08-17
更新作者: 小浩 3489472862
更新内容: 
         1. 修复单独复制一个\n,脚本会崩溃的bug
         2. 添加进入剪切板后自动隐藏状态栏的功能
            （需要对应lua包支持，请将自动状态栏.lua放入对应位置）
         3. 删除词条和查看词条中的删除功能会实时写入json文件
         4. 查看词条中的置顶功能会更新系统的剪切板，直接粘贴会变成置顶后内容
         5. 清空词条的时候也会自动恢复状态栏
         6. 剪切板有变化，就会实时刷新
         7. 优化搜索功能的显示
            7.1 关键词会显示在界面中
            7.2 关键词会高亮


自定义剪切板5.0.3
▂▂▂▂▂▂▂▂
当前版本: V5.0.3
更新日期: 2022-06-14
更新作者: 小浩 3489472862
更新内容: 
          1. 修复分词工具无法使用的bug


自定义剪切板5.0.2
▂▂▂▂▂▂▂▂
当前版本: V5.0.2
更新日期: 2022-05-27
更新作者: 小浩 3489472862
更新内容: 
          1. 修复剪切板内容或者搜索结果数量过小时，右边按钮会变小的bug
          2. 重写优化搜索相关功能的代码
          3. 修复剪切板内容框的序号不是由界面控制的bug
          4. 搜索的时候显示的序号修改为其真实序号(会有空位)
          5. 当剪切板内容为空或者搜索结果为空时会有相关提示
          6. 搜索按钮的文字会动态变化
          7. 更新记录不在放在帮助说明内部而采用注释的形式存在
          8. 修复当搜索内容过长时，标题显示不全的问题
          9. 复制和剪切后自动刷新剪切板
          10. 在搜索界面也可以将词条进行置顶删除等操作
          11. 修复🔝置顶词条后还顺便粘贴出原来内容的bug
          

自定义剪切板5.0.1
▂▂▂▂▂▂▂▂
更新时间: 2022年05月13日
更新作者: 小浩 3489472862
更新内容: 
          1. 标题还是添加了版本号，文件名中不添加版本号，
             在更新剪切板时无需再次修改主题
          2. 修复撤销和重做长按也会执行的bug
          3. 更新了布局

自定义剪切板5.0
▂▂▂▂▂▂▂▂
更新时间: 2022年05月12日
更新作者: 小浩 3489472862
更新内容: 
          1. 添加🔝置顶词条
          2. 长按删除键可以连续删除
          3. 长按空格连续输出空格
          4. 默认键盘的键盘名由"K_default"修改为"Keyboard_default"，以修复无法返回主键盘的bug
          5. 注释了单击上屏内容后直接置顶的功能，如果想要取消可搜索
                  --置顶已上屏内容
                -- Clip.remove(p)
                -- Clip.add(0,s)
                -- fresh(Clip)
          6. 将清除功能移到🚮清空词条防止误点击
          7. 将原清除功能改为TAB(并没用显示在按键上)
          8. 修复复制大量内容（网页源码）的时候剪切板打开异常卡顿的bug
          9. 修改剪切板内容文字颜色，修改背景颜色
          10. 剪切板内容序号后面添加了一个空格
          11. 修改整体布局，添加了一些按键（全选，复制，剪切，撤销（长按行首），重做（长按行尾），方向键（支持长按连续））
          12. 添加背景图片功能（同目录下"bg.jpg"的图片），视频背景改为"bg.mp4",
              如果同时存在视频背景和图片背景，优先使用视频背景
          13. 修改键盘名的判定条件，防止返回按钮输出文字而无法返回键盘
          --14. 版本号在文件名中添加了，不再标题中添加版本号，防止重复
          15. 修改了删除词条和分割词条前面的emoji表情
          16. 删除📑复制词条功能，表示不理解有什么用
          17. 添加👀查看词条功能（原来3点几版本的长按预览功能）
          18. 当没有放置视频背景以及图片背景时
              会读取当前主题配色的keyboard_back_color作为剪切板背景
              支持纯色以及图片
              **注意: 
              1. 该功能需要在当前使用的配色里面设置keyboard_back_color
              2. 记得需要重新部署一下
          19. 背景优先级：bg.mp4 > bg.jpg > 主题配色背景色


本次更新: 2021.10.09
By＠合欢∣hehuan.ys168.com
增加生成二维码，增加语音播报，增加一键加词自动编码，增加推送到云端，增加从云端获取(点击剪切板标题获取)，增加分词
优化搜索
版本号: 4.0

无障碍版专用脚本
脚本名称: 自定义剪切板
说明：中文输入法无障碍版原生剪切板优化版,基于 星乂尘_自定义剪切板3.1 修改
增加搜索,优先首选,选中内容
版本号: 3.5
▂▂▂▂▂▂▂▂
日期: 2020年12月08日🗓️
农历: 鼠🐁庚子年十月廿四
时间: 18:26:19🕕
星期: 周二
制作者: 风之漫舞
首发qq群: Rime 同文斋(458845988)
邮箱: bj19490007@163.com(不一定及时看到)


中文输入法脚本
自定义剪切板
原作者： 星乂尘 1416165041@qq.com
2020.09.04



</big><font color=red><b>帮助说明</b></font></big>
--脚本配置说明
<b>用法一</b>
①放到脚本启动器->脚本库目录 下任意位置及子文件夹中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,
单击上屏文字

--------------------
<b>用法二</b>
第①步 将 脚本文件解压放置 Android/rime/script 文件夹内,
默认脚本路径为Android/rime/script/自定义剪切板/自定义剪切板.lua

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys,加入以下内容

preset_keys:
  lua_script_cvv: {label: 剪切板, functional: false, send: function, command: "自定义剪切板/自定义剪切板.lua", option: "default"}
向该主题方案任意键盘按键中加入上述按键既可

]]




require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.RectF"
import "android.media.MediaPlayer"
import "android.graphics.drawable.StateListDrawable"
import "java.io.File"
import "android.text.Html"
import "android.os.*"
import "com.osfans.trime.*" --载入包
import "android.graphics.Typeface"
import "android.content.Context" 
import "android.speech.tts.*"
import "yaml"
import "java.math.BigInteger"


local 输入法目录=tostring(service.getLuaExtDir("")).."/"
local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)
local 脚本相对目录=string.sub(脚本相对路径,1,-#纯脚本名-1)
local 主题组=Config.get()
local 当前主题0=主题组.getTheme()
local 主题文件=输入法目录.."build/"..当前主题0..".yaml"
local yaml组 = yaml.load(io.readall(主题文件))

local 版本号="5.0.6"
local 标题=纯脚本名:sub(1,-5) .. 版本号
local clipMaxNum = Function.getPref(this).getString("Phrase_size", "120")


if File(输入法目录 .. "script/包/键盘操作/功能键.lua").exists() then
  import "script.包.键盘操作.功能键"
end

if File(输入法目录 .. "script/包/键盘操作/自动状态栏.lua").exists() then
  import "script.包.键盘操作.自动状态栏"
end


--用于清空词条
local 文件=tostring(service.getLuaDir("")).."/Phrase.json"

local Clip=service.getPhrase()

local func_fresh = nil
local func_ss = nil

-- 辅助函数------------开始------------

--长按连续按键
local ButLongclick=(function(key)
  local height=0
  return {onTouch=function(v,e)
      local a=e.getAction()
      if a==0 --按下
        service.sendEvent(key)
        height=v.getHeight()
      elseif a==1 --抬指
        ti.stop()
      elseif a==2 --滑动
        if tick[1]
          local y=e.getY()
          if e.getX()<1 or y<1 or y>height
            ti.stop()
          end
        end
      end
      end,onLongClick=function()
        ti=Ticker()
        ti.Period=80
        ti.onTick=function ()
          service.sendEvent(key)
        end
        ti.start()
      return true
  end}
end)

--转为整数
local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

--导入模块
function 导入模块(模块,内容)
   dofile_信息表=nil
   dofile_信息表={}
   dofile_信息表.上级脚本=脚本路径
   dofile_信息表.上级脚本所在目录=目录
   dofile_信息表.上级脚本相对路径=脚本相对路径
   dofile_信息表.纯脚本名= 纯脚本名:sub(1,-5)
   dofile_信息表.内容=内容
   dofile(目录..模块)--导入模块
end

function rippleDrawable(color)
  import"android.content.res.ColorStateList"
  return activity.Resources.getDrawable(activity.obtainStyledAttributes({android.R.attr.selectableItemBackground--[[Borderless]]}).getResourceId(0,0)).setColor(ColorStateList(int[0].class{int{}},int{color or 0x20000000}))
end

--线性渐变
function gradientDrawable(orientation,colors)
  import"android.graphics.drawable.GradientDrawable"
  return GradientDrawable(GradientDrawable.Orientation[orientation],colors)
end

--注册剪切板添加广播
import "android.content.BroadcastReceiver"
import "android.content.IntentFilter"
import "com.androlua.LuaBroadcastReceiver"
function 剪切板添加广播()
  br=LuaBroadcastReceiver(LuaBroadcastReceiver.OnReceiveListener{
    onReceive=function(context, intent)
      if intent.getAction()=="com.nirenr.talkman.ACTION_ADD_Phrase" then
        if intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~="" or intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~=nil then
          func_fresh()
        end --intent.getStringExtra
      end --intent.getAction
    end --function(conte
  })
  --动态注册广播接收者
  filter=IntentFilter()
  filter.addAction("com.nirenr.talkman.ACTION_ADD_Phrase")
  filter.setPriority(Integer.MAX_VALUE)
  --开启广播接收
  service.registerReceiver(br,filter)
  全_br = true
end
  
--清理剪切板
local function clipClean()
  -- print("clip clean...")
  local 清理正则组={
  "^http%S*$", --清理纯链接
  }
  local zs = 0
  --倒序循环
  for i=#Clip-1, 0, -1 do
    --过长删除
    if #Clip[i] > 1000 then
      zs = zs + 1
      Clip.remove(i)
    end
    
    --正则清理
    for j=1, #清理正则组 do
      if string.find(Clip[i], 清理正则组[j]) ~= nil then
        zs = zs + 1
        Clip.remove(i)
      end
    end
  end
  print("共清理" .. zs .. "条数据")
  func_fresh()
end


-- 辅助函数------------结束------------

-- 字体设置------------开始------------

local vibeFont=Typeface.DEFAULT
local 字体文件 = tostring(service.getLuaDir("")).."/fonts/牛码飞机手机5代超集宋体.ttf"
if File(字体文件).exists()==true then
  vibeFont=Typeface.createFromFile(字体文件)
end--if File(字体文件)

-- 字体设置------------结束------------

-- 自动背景颜色和背景图片------------开始------------

local 背景颜色 = nil
--图片路径
local bgpic_path=目录.."bg.jpg"
local 当前配色ID=Config.get().getColorScheme()
local 当前配色背景 = yaml组["preset_color_schemes"][当前配色ID]["keyboard_back_color"]
local 当前配色背景颜色 = toint(当前配色背景)
if 当前配色背景颜色 != nil then
  --背景颜色
  背景颜色 = "0x" .. BigInteger(tostring(当前配色背景颜色), 10).toString(16)
elseif 当前配色背景 != nil and File(bgpic_path).isFile()==false then
  --说明是背景图片
  bgpic_path = 输入法目录 .. "backgrounds/" .. 当前配色背景
end

-- 自动背景颜色和背景图片------------结束------------
local 当前配色ID=Config.get().getColorScheme()
local fontColorConf=0xffE3E3E3
if  当前配色ID !="weixin1" then
  fontColorConf=0xffE3E3E3
elseif	当前配色ID !="weixin2" then
  fontColorConf=0xff333333
end
-- 搜索功能------------开始------------

--优先级
-- 参数 >>  状态栏  >>  选中文本 >>  上次上屏 
-- 这里不考虑启动参数
local 预搜索内容=""
local isSearch = false
local function getSearchStr()
  if Rime.RimeGetInput()~="" then
    预搜索内容 = Rime.getComposingText()  --当前候选
  else
    预搜索内容 = service.getCurrentInputConnection().getSelectedText(0)--取编辑框选中内容,部分app内无效
  end
  if 预搜索内容 == "" or 预搜索内容 == nil then
    预搜索内容 = Rime.getCommitText() --己上屏文字
  end
end
--解除下面注释则启动立刻进行搜索
--getSearchStr()
if 预搜索内容 != "" and  预搜索内容 != nil then
  isSearch = true
end
-- 搜索功能------------结束------------



local num = 0 --当前选择的序号
local str = "" --当前选择的内容
local arrNo={} --内容序号数组，里面保存Clip的位置序号
local function getNumStr(p)
  num = arrNo[p+1]
  str = Clip[num]
end


--生成功能键背景
local function Back() 
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

local stb,state=StateListDrawable(),android.R.attr.state_pressed
  stb.addState({-state},bkb)
  stb.addState({state},bka)
  return stb
end

--获取k功能图标，没有则返回s
local function Icon(k,s) 
  k=Key.presetKeys[k]
  return k and k.label or s
end

--生成功能键
local function Bu_R(id) 
  local ta={TextView,
  gravity=17,
  Background=Back(),
  layout_height=-1,
  layout_width=-1,
  layout_weight=1,
  layout_margin="1dp",
  layout_marginTop="2dp",
  layout_marginBottom="2dp",
  textColor=fontColorConf,
  textSize="18dp"}

  if id==1 then
    ta.text=Icon("BackSpace","⌫")
    ta.textSize="22dp" --字体大小设置为22dp
    ta.OnTouchListener=ButLongclick("BackSpace")
    ta.OnLongClickListener=ButLongclick("BackSpace")
  elseif id==2 then
    ta.text="空格"
    ta.textSize="18dp"
    ta.OnTouchListener=ButLongclick("space")
    ta.OnLongClickListener=ButLongclick("space")
  elseif id==3 then
    ta.text=Icon("Return","⏎")
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("Return")
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
  elseif id==11 then
    ta.text=Icon("Keyboard_default","返回")
    ta.onClick=function()
      service.sendEvent("End")
      service.setKeyboard("K_default")
      pcall(function()
      --pcall里防报错
        恢复状态栏()
      end)
    end
    ta.OnLongClickListener={onLongClick=function()
      service.setKeyboard(".default")
      pcall(function()
      --pcall里防报错
        恢复状态栏()
      end)
      return true
    end}
  elseif id==5 then
    ta.text=Icon("Tab","Tab")
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("Tab")
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
  elseif id==10 then
    ta.id = "ss" --ss: 搜索
    if isSearch then
      ta.text=Icon("全部","全部")
    else
      ta.text=Icon("搜索","搜索")
    end
    ta.textSize="18dp"
    ta.onClick=function()
      if isSearch then
        isSearch = false
        func_ss("搜索")
      else
        isSearch = true
        func_ss("全部")
      end
      getSearchStr()
      func_fresh()
    end
  elseif id==4 then
    ta.text=Icon("剪切","剪切")
    ta.textSize="18dp"
    ta.onClick=function()
      if 功能_脚本 != nil then
        功能_脚本(脚本相对目录.."剪切板.lua","短语板")
      else
        print('【脚本】功能需要"功能键.lua"的支持！请确保"script/包/键盘操作/功能键.lua]文件存在"')
      end
      end
        elseif id==18 then
    ta.text=Icon("撤销","撤销")
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("undo")
    end
    ta.OnLongClickListener={onLongClick=function()
      --长按行首
      service.sendEvent("Home")
      return true
    end}
  elseif id==12 then
    ta.text="清理"
    ta.textSize="18dp"
    ta.onClick=function()
      clipClean()
    end
    ta.OnLongClickListener={onLongClick=function()
      return true
    end}
  end
  return ta
end

local 默认高度=service.getLastKeyboardHeight()
if 默认高度<300 then 默认高度=300 end
if lua高度 != nil and lua高度 != "" then
  默认高度 = lua高度
end

--主界面布局
local ids,layout={},{FrameLayout,
    --键盘高度
    layout_height=默认高度,
    layout_width=-1,
    --背景颜色
    BackgroundColor=背景颜色,
    {TextView,
        id="title",
        layout_height="0.5dp",
        layout_width=-1,
        text="•帮助说明",
        gravity="center",
        paddingLeft="2dp",
        paddingRight="2dp",
        singleLine="true",
        BackgroundColor=0x49d3d7da,
        },
    {LinearLayout,
        orientation=0,--水平布局
        layout_height=-1,
        {LinearLayout,
            orientation=1,--垂直布局
            layout_weight=1,
            layout_height=-1,
            {LinearLayout,
            layout_marginTop="20dp", --和标题高度相等
            orientation=0,--水平布局
            layout_width=-1,
            layout_height="0dp",
            --Bu_R(7),
            --Bu_R(8),
            --Bu_R(9),
            --Bu_R(12),
            --Bu_R(13),
            --Bu_R(14),
            --Bu_R(15),
            --Bu_R(16),
            --Bu_R(17),
            },
            {ListView, --列表控件
                id="list",
                --layout_marginTop="59dp", --和标题高度相等
                --DividerHeight=0,  --无间隔线
                layout_width=-1,
                layout_weight=1},
        },
            
        {LinearLayout,
            --layout_marginTop="59dp", --和标题高度相等
            layout_marginTop="0dp", --和标题高度相等
            orientation=1,
            layout_weight=1,
            layout_width="130dp",
            layout_height=-1,
            layout_gravity=5|84,
            Bu_R(11),
            Bu_R(1),
            Bu_R(18),
            Bu_R(10),
            --Bu_R(3),
            Bu_R(4),
            }
    }
}

layout=loadlayout(layout,ids)

--剪切板内容框
local data,item={},{LinearLayout,
  layout_width=-1,
  padding="4dp",
  gravity=3|17,
  {TextView,
  id="TV_a",
  textColor=fontColorConf,
  textSize="10dp"},
  {TextView,
  id="TV_b",
  gravity=3|17,
  paddingLeft="4dp",
  --最大显示行数
  MaxLines=3,
  --最小高度
  MinHeight="30dp",
  Typeface=vibeFont,
  textColor=fontColorConf,
  textSize="15dp"}}

local adp=LuaAdapter(service,data,item)
ids.list.Adapter=adp


local function fresh()
  -- print("fresh")
  table.clear(data)
  table.clear(arrNo)
  local 正则式 = ""
  if isSearch then
    for i=0,#Clip-1 do
      local m=utf8.find(Clip[i],预搜索内容)
      if m~=nil then
        table.insert(arrNo,i)
      end
    end
    ids.title.setText(标题.."(搜索到"..#arrNo.."条) \""..预搜索内容.."\" 相关内容")
    正则式 = "(\n*[^\n]*)([^\n]*"..预搜索内容.."[^\n]*)(\n*[^\n]*)"
  else
    for i=0,#Clip-1 do
      arrNo[i+1] = i
    end
    ids.title.setText(标题.."("..#arrNo.. "/" .. clipMaxNum ..")")
    正则式 = "(\n*[^\n]*)(\n*[^\n]*)(\n*[^\n]*)"
  end
  for i=1,#arrNo do
    local v=Clip[arrNo[i]]
    local a,b,c=v:match(正则式)
    a=table.concat{utf8.sub(a or "",1,99),utf8.sub(b or "",1,99),utf8.sub(c or "",1,99)}
    a=a:gsub(".",{
      ["<"]="&lt;",
      [">"]="&gt;",
    })
    a=string.gsub(a,"\n","<br>")
    if isSearch then
      a=string.gsub(a,预搜索内容,"<font color=#00ff00>" .. 预搜索内容 .. "</font>")
    end
    table.insert(data,{TV_a=Html.fromHtml("</big><font><b>"..tostring(arrNo[i] + 1)..". </b></font></big>"),TV_b=Html.fromHtml(a)})
  end
  if #arrNo == 0 then
    if isSearch then
      table.insert(data,{TV_a=Html.fromHtml("</big><font><b>"..tostring(1)..". </b></font></big>"),TV_b=Html.fromHtml("未搜索到【" .. "<font color=#00ff00>" .. 预搜索内容 .. "</font>" .. "】相关内容")})
    else
      table.insert(data,{TV_a=Html.fromHtml("</big><font><b>"..tostring(1)..". </b></font></big>"),TV_b=Html.fromHtml("短语板中无内容！")})
    end
  end
  adp.notifyDataSetChanged()
  func_ss = ids.ss.setText --刷新以后id会重置
end

ids.list.onItemClick=function(l,v,p)
  getNumStr(p)
  service.commitText(str)
end

ids.list.onItemLongClick=function(l,v,p)
  getNumStr(p)
  pop=PopupMenu(service,v)
  menu=pop.Menu
  menu.add("🔝置顶词条").onMenuItemClick=function(ae)
    Clip.remove(num)
    Clip.add(0,str)
    service.getSystemService(Context.Phrase_SERVICE).setText(str)
    --fresh() 监听了剪切板事件，自动会刷新
  end
  menu.add("👀查看词条").onMenuItemClick=function(ae)
    local lay={TextView,
    padding="16dp",
    MaxLines=20,
    textIsSelectable=true,
    text=str,
    textColor=0xff232323,
    textSize="15dp"}
    LuaDialog(service)
    .setTitle(string.format("%s.  预览/操作（%s）",num+1,utf8.len(str)))
    .setView(loadlayout(lay))
    .setButton("置顶",function()
      if p>0 then
        Clip.remove(num)
        Clip.add(0,str)
        service.getSystemService(Context.Phrase_SERVICE).setText(str)
        --fresh() 监听了剪切板事件，自动会刷新
      end
    end)
    .setButton2("删除",function()
      Clip.remove(num)
      fresh()
      JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
    end)
    .setButton3("取消",function()
      dialog.dismiss()
    end)
    .show()
  end
  menu.add("🗑️删除词条").onMenuItemClick=function(ae)
    Clip.remove(num)
    fresh()
    JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
  end
  menu.add("🈹分割词条").onMenuItemClick=function(ae)
    导入模块("分词工具.text",str)
  end
  menu.add("🚮清空词条").onMenuItemClick=function(ae)
    pcall(function()
    --pcall里防报错
      恢复状态栏()
    end)
    io.open(文件,"w"):write("[\n]"):close()
    local 输入法实例=Trime.getService()
    输入法实例.loadPhrase()
    print("数据已清除")
    service.setKeyboard(".default")
  end
  menu.add("📝添加短语").onMenuItemClick=function(ae)
    print(str.."添加成功")
    local Phrase=service.getPhrase()
    Phrase.add(0,str)
    local Phrase_nr="[\n"
    for i=0,#Phrase-1 do
      Phrase0=Phrase[i]:gsub("\\","\\\\")
      Phrase0=Phrase0:gsub("/","\\/")
      Phrase0=Phrase0:gsub("\"","\\\"")
      Phrase0=Phrase0:gsub("\n","\\n")
      Phrase0=Phrase0:gsub("\t","\\t")
      Phrase_nr=Phrase_nr.."    \""..Phrase0.."\",\n"
    end
    Phrase_nr=Phrase_nr:sub(1,-3).."\n]"
    io.open(输入法目录.."phrase.json","w"):write(Phrase_nr):close()
  end
  pop.show()
  return true
end


ids.title.onClick=function()
  导入模块("从云端获取剪切板.text","")
end

fresh()
func_fresh = fresh
if 全_br == nil then
  剪切板添加广播()
end
service.setKeyboard(layout)

pcall(function()
  --pcall里防报错
  隐藏状态栏(layout)
end)

-- 默认视频和默认背景图------------开始------------

--视频路径
local bgmv_path=目录.."bg.mp4"
--视频文件不存在则终止脚本
if File(bgmv_path).isFile()==true then
  pcall(function()
    local play=MediaPlayer()
    play.setDataSource(bgmv_path)
    --循环播放
    play.setLooping(true)
    play.prepare()
    --音量设为0
    play.setVolume(0,0)
  
    local video=loadlayout{SurfaceView,
      --添加背景色，避免看不清按键
      --BackgroundColor=0x55ffffff,
      --线性渐变，"TL_BR"为topleft bottomright
      backgroundDrawable=gradientDrawable("TL_BR",{0x99FBE0B5,0x99E5EED9,0x99F3F5F8}),--背景色
      layout_width=-1,
      layout_height=-1
      }
    layout.addView(video,0) --把视频布局放到layout的第一个，也就是显示在最底层
    
    video.getHolder().addCallback({
      surfaceCreated=function(holder)
        play.start()
        play.setDisplay(holder)
      end,
      surfaceDestroyed=function()
        --界面关闭，释放播放器
        play.release()
    end})
  end)
elseif File(bgpic_path).isFile()==true then
  local pic=loadlayout{ImageView,
    --添加背景色，避免看不清按键
    --BackgroundColor=0x55ffffff,
    --线性渐变，"TL_BR"为topleft bottomright
    backgroundDrawable=gradientDrawable("TL_BR",{0x99FBE0B5,0x99E5EED9,0x99F3F5F8}),--背景色
    src=bgpic_path,
    --adjustViewBounds="true",--保持长宽比
    scaleType="fitXY",--横向纵向缩放
    layout_width=-1,
    layout_height=-1}
  layout.addView(pic,0) --把视频布局放到layout的第一个，也就是显示在最底层
end


-- 默认视频和默认背景图------------结束------------


