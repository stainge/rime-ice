--自动脚本，配合新版方案脚本自动启动
--使用方法，放到rime/script_auto/既可

require "import"
import "android.content.*"
import "com.osfans.trime.*" --载入包
import "android.view.KeyEvent"
local function 主题跟随系统深色模式()

	--自动切换深色(根据时间)
	--[[
	local H = tonumber(os.date("%H"))
	local 当前配色ID=Config.get().getColorScheme()
	local 浅色配色ID= "default"
	local 深色配色ID= "m"

	if H > 19 or H<7 then
		if 当前配色ID ~=深色配色ID then
			Config.get().setColor(深色配色ID)--设置配色
			--service.invalidate()--刷新当前键盘
			Trime.getService().initKeyboard()--重新载入键盘
			--service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)--模拟返回键
			print("已切换到深色配色")
		end
	else
		if 当前配色ID == 深色配色ID then
			Config.get().setColor(浅色配色ID)--设置配色
			--service.invalidate()--刷新当前键盘
			Trime.getService().initKeyboard()--重新载入键盘
			--service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)--模拟返回键
			print("已切换到浅色配色")
		end
	end
	--]]
	--跟随系统深色
	--
	local configuration=service.getResources().getConfiguration();
	local 夜间模式=configuration.uiMode
	local 当前配色ID=Config.get().getColorScheme()
	local 浅色配色ID= "default"
	local 深色配色ID= "yjg"
	if 夜间模式 == 33 then
		--print("这是深色")
		if 当前配色ID ~=深色配色ID then
			Config.get().setColor(深色配色ID)--设置配色
			--service.invalidate()--刷新当前键盘
			Trime.getService().initKeyboard()--重新载入键盘
			--service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)--模拟返回键
			print("已切换到深色配色")
		end
	elseif 夜间模式 == 17 then
		--print("这是浅色") 
		if 当前配色ID == 深色配色ID then
			Config.get().setColor(浅色配色ID)--设置配色
			--service.invalidate()--刷新当前键盘
			Trime.getService().initKeyboard()--重新载入键盘
			--service.onKey(KeyEvent.KEYCODE_ESCAPE, 0)--模拟返回键
			print("已切换到浅色配色")
		end
	end
	--]]
end
return {实时运行=主题跟随系统深色模式,刷新键盘=主题跟随系统深色模式}

