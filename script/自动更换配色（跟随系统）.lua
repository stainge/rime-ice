--自动脚本，配合新版方案脚本自动启动
--使用方法，放到rime/script_auto/既可

require "import"
import "android.content.*"
import "com.osfans.trime.*" --载入包
import "android.view.KeyEvent"
local function 刷新键盘()
    --跟随系统深色
    local configuration=service.getResources().getConfiguration();
    local 夜间模式=configuration.uiMode
    local 当前配色ID=Config.get().getColorScheme()
    local 浅色配色ID= "default"
    local 深色配色ID= "k"

    if 夜间模式 == 33 then
        --print("这是深色")
        if 当前配色ID ~=深色配色ID then
            Config.get().setColor(深色配色ID)--设置配色
            Trime.getService().initKeyboard()
            --print("已切换到Black Key")
        end
    elseif 夜间模式 == 17 then
        --print("这是浅色")
        if 当前配色ID == 深色配色ID then
            Config.get().setColor(浅色配色ID)--设置配色
            Trime.getService().initKeyboard()
            --print("已切换到White Key")
        end
    end
end
return {刷新键盘=刷新键盘}
