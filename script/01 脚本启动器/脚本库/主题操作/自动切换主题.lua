require "import"
import "java.io.*"
import "android.content.*"

import "com.osfans.trime.*" --载入包

local configuration=service.getResources().getConfiguration();
夜间模式=configuration.uiMode
local 当前主题=Config.get().getTheme()
if 夜间模式 == 33 then
--print("这是深色")
if 当前主题 == "trime" then
service.sendEvent("LuaTheme2")
  end
  elseif 夜间模式 == 17 then
--print("这是浅色")
if 当前主题 == "Silver Bullet 2021 深色.trime" then
service.sendEvent("LuaTheme1")
  end
end


