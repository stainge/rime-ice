;--[[
--无障碍版专用脚本
--用途：一键加词
--如何使用: 请参考群文件，路径[同文无障碍LUA脚本]->同文无障碍版lua脚本使用说明.pdf
--感谢风老师的细心指导🐂🍺
--配置说明

第①步 将 一键加词.lua 文件放置 rime/script 文件夹内，修改lua内单字码表路径、主码表路径

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
preset_keys:
  yjjc_lua: {label: 一键加词, send: function, command: '一键加词.lua', option: "《《命令行》》【【词库名.txt】】"}#词库名称为自定义项
向任意按键加入上述按键既可

第③步 在任意输入框输入“词条+tab符号”，例如 星空两笔	
然后点击第②步添加的按键即可
]]
require "import"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.io.File"
import "com.osfans.trime.*" --载入包
import "script.包.字符串.其它"
import "script.包.其它.主键盘"
import "android.widget.*"
import "android.view.*"
import "android.graphics.RectF"
import "java.io.*"
import "com.osfans.trime.*" --载入包
import "android.text.Html"
import "android.graphics.drawable.StateListDrawable"
import "yaml"
local 词库文件=tostring(service.getLuaDir("")).."/Sapphire.plus.txt"--用户码表
local 词库文件2=tostring(service.getLuaDir("")).."/Sapphire.foruser.txt"--用户码表
local 单字码表路径=tostring(service.getLuaDir("")).."/Sapphire.single.dict.yaml"--单字码表
local 参数=(...)
Key.presetKeys.lua_script_1={label= '全选', send= "Control+a"}
Key.presetKeys.lua_script_2={label= '删除', send="BackSpace"}
service.sendEvent("lua_script_1")
local 词组和制表符 = service.getCurrentInputConnection().getSelectedText(0)--取编辑框选中内容,部分app内无效
   if 参数!=nil && string.find(参数,"《《命令行》》")!=nil then
	 词库文件 = utf8.sub(参数, 10, -3)
	 词库文件 = tostring(service.getLuaDir("")).."/"..词库文件
   end
if 词组和制表符== nil or 词组和制表符=="" then
do return end --强制退出
end

--刷新方案
local function sxfv(a)
	if a==1 then
		local 方案组=Rime.getSchemaNames() --返回输入法方案组
		if #方案组==1 then
			print("当前只有1个方案,无法切换,请保证有两个方案")
			return --退出
		end
		local 方案编号=Rime.getSchemaIndex()
		local 切换编号=0
		if 方案编号==0 then 切换编号=1 end
			local 结果=Rime.selectSchema(切换编号)
			Rime.selectSchema(方案编号)
		if 结果==false then print("方案切换失败,请保证有两个方案") end
	end
end

if string.find(词组和制表符,"	") != nil && #词组和制表符>0 && 字符串首尾空(词组和制表符)!="" && #词组和制表符<99 then

local 词组=string.match(词组和制表符,"(.+)	")
local n=utf8.len(词组)
local 编码组={}
local a={}
local b={}
local q={}
local f={}
local e={}
local i=1
local k=1
local d=1
local p=1
local m=1
	if n==2 then
		for c in io.lines(单字码表路径) do
			if utf8.sub(c,1,1)== utf8.sub(词组,1,1) then
				a[i]=string.match(c,"\t(..)")
				i=i+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,2,2)then
				b[k]=string.match(c,"\t(..)")
				k=k+1
			end
		end
		for i =1,#a do
			for n =1,#b do
				e[m]=a[i]..b[n]
				m=m+1
			end
		end
		
		for i=1,#e do
			编码组[i]=词组.."\t"..e[i]
		end
		
		
	elseif n==3 then
		for c in io.lines(单字码表路径) do
			if utf8.sub(c,1,1)== utf8.sub(词组,1,1) then
				a[i]=string.match(c,"\t(..)")
				i=i+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,2,2) then
				b[k]=string.match(c,"\t(..)")
				k=k+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,3,3) then
				q[d]=string.match(c,"\t(..)")
				d=d+1
			end
		end
		for i =1,#a do
			for n =1,#b do
				for t =1,#q do
					e[m]=a[i]..b[n]..q[t]
					m=m+1
				end
			end
		end
		
		for i=1,#e do
			编码组[i]=词组.."\t"..string.sub(e[i],1,1)..string.sub(e[i],3,3)..string.sub(e[i],5,5)
			编码组[#e+i]=词组.."\t"..string.sub(e[i],1,1)..string.sub(e[i],3,3)..string.sub(e[i],5,6)
		end
		
	elseif n>=4 then
	for c in io.lines(单字码表路径) do
			if utf8.sub(c,1,1)== utf8.sub(词组,1,1) then
				a[i]=string.match(c,"\t(..)")
				i=i+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,2,2) then
				b[k]=string.match(c,"\t(..)")
				k=k+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,3,3) then
				q[d]=string.match(c,"\t(..)")
				d=d+1
			end
			if utf8.sub(c,1,1)== utf8.sub(词组,-1,-1) then
				f[p]=string.match(c,"\t(..)")
				p=p+1
			end
		end
		for i =1,#a do
			for n =1,#b do
				for t =1,#q do
					for s =1,#f do
						e[m]=a[i]..b[n]..q[t]..f[s]
						m=m+1
					end
				end
			end
		end
		
		for i=1,#e do
			编码组[i]=词组.."\t"..string.sub(e[i],1,1)..string.sub(e[i],3,3)..string.sub(e[i],5,5)..string.sub(e[i],7,7)
		end
		
	end  --if n>=4 then

--]]
if #编码组==1 then
  io.open(词库文件,"a+"):write("\n"):close()
  io.open(词库文件,"a+"):write(编码组[1]):close()
  service.sendEvent("lua_script_2")
  Toast.makeText(service," 词组【"..编码组[1].."】 添加成功☑",2000).show()
  sxfv(1)--刷新方案
elseif  #编码组>1 then

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

local function Icon(k,s) --获取功能键图标
  k=Key.presetKeys[k]
  return k and k.label or s
end

local function Bu_R(id) --生成功能键
  local ta={TextView,
    gravity=17,
    Background=Back(),
    layout_height=-1,
    layout_width=-1,
    layout_weight=1,
    layout_margin="1dp",
    layout_marginTop="2dp",
    layout_marginBottom="2dp",
    textColor=0xff232323,
    textSize="18dp"}

  if id==1 then
    ta.text=Icon("返回","返回")
    ta.onClick=function()
    主键盘_返回()
    end
  end
  return ta
end

local ids,layout={},{FrameLayout,
  --键盘高度
  layout_height=service.getLastKeyboardHeight(),
  layout_width=-1,
  --背景颜色，默认透明
  BackgroundColor=0x88ffffff,
  {ListView,
    id="list",
    layout_width=-1},
  {LinearLayout,
    orientation=1,
    --右侧功能键宽度
    layout_width="70dp",
    layout_height=-1,
    layout_gravity=5|84,
    Bu_R(1),
    }}
layout=loadlayout(layout,ids)

local data,item={},{LinearLayout,
  layout_width=-1,
  padding="4dp",
  gravity=3|17,
  {TextView,
    id="a",
    textColor=0xff232323,
    textSize="20dp"},
  {TextView,
    id="b",
    gravity=3|17,
    paddingLeft="4dp",
    --最大显示行数
    MaxLines=3,
    --最小高度
    MinHeight="30dp",
    textColor=0xff232323,
    textSize="20dp"}}
local adp=LuaAdapter(service,data,item)
ids.list.Adapter=adp

local Clip=编码组
local function fresh()
  table.clear(data)
  for i=0,#Clip-1 do
    local v=Clip[i+1]
    local a,b,c=v:match("^%s*([^\n]+)(\n*[^\n]*)(\n*[^\n]*)")
 a=table.concat{utf8.sub(a or "",1,99),utf8.sub(b or "",1,99),utf8.sub(c or "",1,99)}
    table.insert(data,{a=tostring(i+1),b=a})
  end
  adp.notifyDataSetChanged()
end
fresh()

ids.list.onItemLongClick=function(l,v,p)
  local str=Clip[p+1]
  local lay={TextView,
    padding="30dp",
    MaxLines=20,
    textIsSelectable=true,
    text=utf8.sub(str,1,3000)..(utf8.len(str)>3000 and "\n..." or ""),
    textColor=0xff232323,
    textSize="20dp"}
  LuaDialog(service)
  .setTitle(string.format("                    词条%s",p+1))
  .setView(loadlayout(lay))
  .setButton("添加到通用词库",function()
      io.open(词库文件,"a+"):write("\n"):close()
      io.open(词库文件,"a+"):write(Clip[p+1]):close()
      Toast.makeText(service," 词组【"..Clip[p+1].."】 添加成功☑",2000).show()
      sxfv(1)--刷新方案
  end)
  .setButton2("添加到用户词库",function()
      io.open(词库文件2,"a+"):write("\n"):close()
      io.open(词库文件2,"a+"):write(Clip[p+1]):close()
      Toast.makeText(service," 词组【"..Clip[p+1].."】 添加成功☑",2000).show()
      sxfv(1)--刷新方案
  end)
  .setButton3("取消",function()
  	return
  end)
  .show()
  --返回（真），否则长按也会触发点击事件
  return true
end

service.setKeyboard(layout)

end

else
  service.sendEvent("lua_script_2")
  print("当前词条不符合编码规则")
--]]
end--string.find(词组和制表符,"	")

