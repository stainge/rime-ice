require "import"
import "com.osfans.trime.*" --载入包
import "android.content.Context" 

local 输入法目录=tostring(service.getLuaExtDir("")).."/"
local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)

--取编辑框选中内容,部分app内无效
local 选中内容=service.getCurrentInputConnection()
if 选中内容!=nil then
  选中内容=选中内容.getSelectedText(0)
end
if 选中内容==nil then
  import "android.content.Context"  --导入类
  选中内容=tostring(service.getSystemService(Context.CLIPBOARD_SERVICE).getText()) --获取剪贴板 
end


function 功能_全选()
 Key.presetKeys.lua_Keyboard={label="全选", send="Control+a"}
 service.sendEvent("lua_Keyboard")
end

function 功能_剪切()
	service.getSystemService(Context.CLIPBOARD_SERVICE).setText(选中内容)
	service.commitText("")
end

function 功能_复制()
	service.getSystemService(Context.CLIPBOARD_SERVICE).setText(选中内容)
end

function 功能_删除()
 Key.presetKeys.lua_Keyboard={label="删除", send="BackSpace"}
 service.sendEvent("lua_Keyboard")
end

function 功能_部署()
Key.presetKeys.lua_Keyboard={label= '重新部署', send= "function", functional= "false", command= "broadcast", option="com.osfans.trime.deploy"}
service.sendEvent("lua_Keyboard")
end

function 功能_脚本(路径,参数)
Key.presetKeys.lua_Keyboard={label= "脚本", send="function", command=路径, option=参数}
service.sendEvent("lua_Keyboard")
end

