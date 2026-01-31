
local 版本号="3.01"

local 帮助内容=[[
</big><font color=red><b>帮助说明</b></font></big>
--无障碍版专用脚本
--脚本名称: 主题操作
--用途：提供预览,刷新,切换以及长按编辑输入法主题的功能
--版本号: 3.01
▂▂▂▂▂▂▂▂
日期: 2020年11月23日🗓️
农历: 鼠🐁庚子年十月初九
时间: 16:14:34🕓
星期: 周一
--制作者: 风之漫舞
--首发qq群: Rime 同文斋(458845988)
--邮箱: bj19490007@163.com(不一定及时看到)

--主题文件预览图配置说明
以 tongwenfeng.trime.yaml 主题为例
当输入法路径为Android/rime/时
脚本自动匹配以下路径png文件
①Android/rime/tongwenfeng.png
②Android/rime/tongwenfeng.trime/tongwenfeng.png
③Android/rime/tongwenfeng.trime/预览图.png
④脚本所在路径/图标包/tongwenfeng.png
⑤脚本所在路径/图标包/trime.png
优先级从上到下,依次查找文件存在否,存在则显示
脚本不生成主题预览图片,默认提供 脚本所在路径/图标包/trime.png,如主题无相关图片,可自行截图主题并放到上述指定位置


--脚本配置说明
<b>用法一</b>
①放到脚本启动器->脚本库目录 下任意位置及子文件夹中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,
单击按键切换主题,长按进入输入法内置编辑器编辑文件

--------------------
<b>用法二</b>
第①步 将 脚本文件解压放置 Android/rime/script 文件夹内,
默认脚本路径为Android/rime/script/主题操作/主题操作.lua

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys,加入以下内容

preset_keys:
  LuaTheme0: {label: 主题, send: function, command: '主题操作/主题操作.lua', option: ""}#显示rime目录下所有主题到一个键盘,点击切换并显示
  LuaTheme1: {label: 主题1, send: function, command: '主题操作/主题操作.lua', option: "《《命令行》》【【主题名.trime】】"}#主题名称为自定义项,无后缀名yaml,默认主题命名为trime即可
  LuaTheme_fresh: {label: 刷新主题, send: function, command: '主题操作/主题操作.lua', option: "《《命令行》》【【刷新主题】】"}#刷新当前主题
  LuaTheme_editor: {label: 编辑当前主题, send: function, command: '主题操作/主题操作.lua', option: "《《命令行》》【【编辑当前主题】】"}#编辑当前主题
  
向该主题方案任意键盘按键中加入上述按键既可


]]


require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.RectF"
import "java.io.*"
import "com.osfans.trime.*" --载入包
import "android.text.Html"
import "android.graphics.drawable.StateListDrawable"

--dofile(tostring(service.getLuaExtDir("script")).."/包/其它/主键盘.lua")



local 参数=(...)

local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)

local 主题实例=Config.get()
local 当前主题=tostring(主题实例.getTheme())

local function 刷新当前主题()
  主题实例.setTheme(tostring(当前主题)) 
 local 按键界面=Trime.getService()
 按键界面.initKeyboard()
 print("当前主题已刷新")
 service.sendEvent("Keyboard_default")
end

local function 刷新主题(主题文件)
 主题实例.setTheme(tostring(主题文件)) 
 local 按键界面=Trime.getService()
 按键界面.initKeyboard()
 if 主题文件 == "trime" then
 主题文件="♠合欢♠"
 else
 主题文件=string.sub(主题文件,1,-7)
 end--]]
 print("主题切换为 "..主题文件)
 service.sendEvent("Keyboard_default")
end


if 参数!=nil && string.find(参数,"《《命令行》》")!=nil && string.find(参数,"【【编辑当前主题】】")!=nil then
 local 主题组=Config.get()
 local 主题=主题组.getTheme()
 local 数据文件=tostring(主题)..".yaml"
 service.editFile(数据文件) 
 return
end

if 参数!=nil && string.find(参数,"《《命令行》》")!=nil && string.find(参数,"【【刷新主题】】")!=nil then
 刷新当前主题()
 return
end

if 参数!=nil && string.find(参数,"《《命令行》》")!=nil && string.find(参数,"【【")!=nil && string.find(参数,"trime】】")!=nil then
 local 主题文件=string.sub(参数 ,string.find(参数,"【【")+6,string.find(参数,"】】")-1)
 local 路径=tostring(service.getLuaExtDir("")).."/"..主题文件..".yaml"
 if File(路径).exists()==false then
   print(路径.." 主题文件不存在")
   return
 end
 刷新主题(主题文件)
 return
end



local 主题组1=Config.getThemeKeys(true)

local 主题组={}

--读取数组元素
for i=1,#主题组1 do
 主题组[i]=tostring(主题组1[i-1])
end
table.sort(主题组)--数组排序

local 文件组={}
local 主题名称组={}
--读取数组元素
for i=1,#主题组 do
 文件组[i]=主题组[i]:sub(1,-6)
 主题名称组[i]=主题组[i]:sub(1,-12)
 if 主题组[i]=="tongwenfeng.trime.yaml" then 主题名称组[i]="同文风" end
 if 主题组[i]=="trime.yaml" then 主题名称组[i]="默认" end
 if 主题名称组[i]==当前主题:sub(1,-7) then 主题名称组[i]=主题名称组[i].."</big><font color=red><b>(当前)</b></font></big>" end

 
end




local function 取图标(文件)
 local 图标,图标组="",{}
 local 文件名=File(文件).getName():sub(1,-11)
 图标组[#图标组+1]=tostring(service.getLuaExtDir("")).."/"..文件名.."trime/"..文件名.."png"--取输入法目录同名png文件
 图标组[#图标组+1]=tostring(service.getLuaExtDir("")).."/"..文件名.."trime/预览图.png"--取输入法目录同名png文件
 图标组[#图标组+1]=tostring(service.getLuaExtDir("")).."/"..文件名.."png"

 图标组[#图标组+1]=目录.."图标包/"..文件名.."png"
 图标组[#图标组+1]=目录.."图标包/trime.png"
 for i=1,#图标组 do
   if File(图标组[i]).exists() then 
     图标=图标组[i]
     return 图标
   end 
 end
 return 图标
end




dofile_信息表=nil
dofile_信息表={}
local function 显示帮助(内容)
   dofile_信息表.上级脚本=脚本路径
   dofile_信息表.上级脚本所在目录=目录
   dofile_信息表.上级脚本相对路径=脚本相对路径
   dofile_信息表.纯脚本名=纯脚本名:sub(1,-5)
   dofile_信息表.内容=内容
   
   
   dofile(目录.."帮助模块.text")--导入模块

end




local ids={}
local data={}
local item={LinearLayout,
  layout_width=-1,
  layout_height="110dp",
  padding="2dp",
  orientation="vertical",
  gravity=17,
  {ImageView;
      id="img";
      layout_width="100dp"; 
      layout_height="80dp"; 
      layout_gravity="center"; 
      adjustViewBounds="true"; 
      scaleType="fitXY";
      --layout_width="400dp";
      --layout_height="200dp";
    },
  
  {CardView,
    radius="10dp",
    layout_height="26dp",
    CardElevation=0,
    layout_width=-1,
    BackgroundColor=0x49d3d7da,
    --gravity=3|17,
    
    {LinearLayout,
    layout_width=-1,
    --BackgroundColor=0x49d3d7da,
    --gravity=3|17,
    {TextView,
    id="b",
    textColor=0xffAA7700,
    textSize="14dp"},
    {TextView,
      id="a",
      --padding="8dp",
      --gravity=17,
      layout_width=-1,
      gravity="center",
      --BackgroundColor=0x49d3d7da,
      textColor=0xff232323,
      textSize="14dp"}}}}
      
      
      
local adp=LuaAdapter(service,data,item)


--刷新列表
local function fresh(t)
  ids.title.setText(纯脚本名:sub(1,-5))
  table.clear(data)
  if type(t)~="table" then
    local ts={}
    for a in utf8.gmatch(tostring(t),"%S")
      table.insert(ts,a)
    end
    t=ts
  end
  local i=0
  for _,v in ipairs(t) do
    i=i+1
    local 图标=取图标(主题组[i])
    table.insert(data,{img=图标,b=" "..tostring(i),a=Html.fromHtml(主题名称组[i])})
  end
  
  adp.notifyDataSetChanged()
end




local function Back() --生成功能键背景
  local bka=LuaDrawable(function(c,p,d)
    local b=d.bounds
    b=RectF(b.left,b.top,b.right,b.bottom)
    p.setColor(0xffffffff)
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

local function Icon(k,s) --获取k功能图标，没有返回s
  k=Key.presetKeys[k]
  return k and k.label or s
end

local function Bu_R(id) --生成功能键
  local Bu={LinearLayout,
    layout_height=-1,
    layout_width=-1,
    layout_weight=1,
    padding="2dp",
    {FrameLayout,
      layout_height=-1,
      layout_width=-1,
      Background=Back(),
      {TextView,
        gravity=17|48,
        layout_height=-1,
        layout_width=-1,
        layout_marginTop="2dp",
        textColor=0xff232323,
        textSize="10dp"},
      {TextView,
        gravity=17,
        layout_height=-1,
        layout_width=-1,
        textColor=0xff232323,
        textSize="18dp"}}}
  local msg=Bu[2][2] --上标签
  local label=Bu[2][3] --主标签
  
 
  if id==2 then
    label.text=Icon("Keyboard_default","返回")
    Bu.onClick=function()
      service.sendEvent("Keyboard_default")
    end
   elseif id==1 then
    label.text=Icon("BackSpace","⌫")
    Bu.onClick=function()
      service.sendEvent("BackSpace")
    end
    elseif id==3 then
    label.text="刷新"
    Bu.onClick=function()
      刷新当前主题()
    end
    elseif id==4 then
    label.text="帮助"
    Bu.onClick=function()
      显示帮助(帮助内容)
    end
    Bu.OnLongClickListener={onLongClick=function() return true end}
  end
  return Bu
end

local height="240dp" --键盘高度
pcall(function()
  --键盘自适应高度，旧版中文不支持，放pcall里防报错
  height=service.getLastKeyboardHeight()
end)


local layout={LinearLayout,
  orientation=1,
  --键盘高度
  layout_height=height,
  layout_width=-1,
  --背景颜色
  --BackgroundColor=0xffd7dddd,
  {TextView,
    id="title",
    layout_height="30dp",
    layout_width=-1,
    text="",
    gravity="center",
    paddingLeft="2dp",
    paddingRight="2dp",
    BackgroundColor=0x49d3d7da
    },
    {LinearLayout,
    gravity="right",
    layout_height=-1,
    {LinearLayout,
      id="main",
      orientation=1,
      --右侧功能键宽度
      layout_weight=1,
      layout_height=-1,
      layout_gravity=8|3,
      {GridView, --列表控件
        id="list",
        numColumns=2, --6列
        paddingLeft="2dp",
        paddingRight="2dp",
        layout_width=-1,
        layout_weight=1}},

   {LinearLayout,
      orientation=1,
      layout_weight=1,
      layout_width="100dp",
      layout_height=-1,
      --layout_gravity=5|84,
      Bu_R(4),
      Bu_R(3),
      Bu_R(1),
      Bu_R(2)
      },
}}



layout=loadlayout(layout,ids)




ids.list.Adapter=adp

ids.list.onItemClick=function(l,v,p)
  刷新主题(主题组[p+1]:sub(1,-6))
end

ids.list.onItemLongClick=function(l,v,p)
  service.editFile(tostring(service.getLuaExtDir("")).."/"..主题组[p+1])--用内置编辑器打开文件
  return true
end




  fresh(主题名称组)
  local 标题=纯脚本名:sub(1,-5)
  标题=标题..版本号
ids.title.setText(标题)


local Bus={LinearLayout,
  paddingLeft="2dp",
  layout_width=-1}


ids.main.addView(loadlayout(Bus))


service.setKeyboard(layout)






