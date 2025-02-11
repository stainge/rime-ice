
require "import"
import "java.io.File"--导入File类
import "com.osfans.trime.*" --载入包


function 主键盘_返回()--一键返回主键盘
	Key.presetKeys.lua_script_Keyboard={label="返回", send="Eisu_toggle",select= ".default"}--取首个键盘
	service.sendEvent("lua_script_Keyboard")
end--function 主键盘_返回



