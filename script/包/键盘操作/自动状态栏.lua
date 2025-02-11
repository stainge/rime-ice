--[[
自动状态栏


当前版本: "V1.5"
更新日期: 2022-11-18
更新作者: 小浩 3489472862
更新内容: 
          1. 优化高度获取方式

当前版本: "V1.3"
更新日期: 2022-10-09
更新作者: 小浩 3489472862
更新内容: 
          1. 修复多个lua键盘重复调用时出现高度不断变高的bug

当前版本: "V1.2"
更新日期: 2022-10-08
更新作者: 小浩 3489472862
更新内容: 
           1. 优化调用逻辑
           2. 修复横屏竖屏切换调用的时候高度不正确的bug
           3. 优化部分代码

当前版本: "V1.0"
创建日期: 2022-08-18
创建作者: 小浩 3489472862
功能说明:
         1. 进入lua自动隐藏状态栏
         2. 退出lua自动恢复

使用方法:
         1. 将该lua放入 script/包/键盘操作/ 文件夹内
         2. 对应脚本lua里面导入该包，import "script.包.键盘操作.自动状态栏"
         3. 对应脚本lua在 setKeyboard(layout) 后调用 隐藏状态栏(layout)
         4. 对应脚本lua在返回按钮处调用 恢复状态栏()
         5. 注意：在调用 隐藏状态栏(layout) 前请确保layout变量已经定义
]]


require "import"
import "com.osfans.trime.*" --载入包


hide_candidate = Rime.getOption("_hide_candidate")

local function getTotalKeyboardHeight(w)
  local current_hide_candidate = Rime.getOption("_hide_candidate")
  local totalKeyboardHeight = service.getLastKeyboardHeight()
  if current_hide_candidate == true then
    --在lua界面或者主键盘本身隐藏了状态栏
    return totalKeyboardHeight
  else
    local mConfig = Config.get()

    local candidate_view_height = mConfig.getPixel("candidate_view_height") --候選區高度
    local comment_height = mConfig.getPixel("comment_height") --編碼提示區高度
    local comment_on_top = mConfig.getBoolean("comment_on_top") --編碼提示在上方或右側
    
    -- 这个编码提示应该还可以关闭，这里暂时不考虑关闭的情况
    if comment_on_top == true then
      totalKeyboardHeight = totalKeyboardHeight + candidate_view_height + comment_height
    else
      totalKeyboardHeight = totalKeyboardHeight + candidate_view_height
    end
    return totalKeyboardHeight
  end
end

-- 隐藏状态栏
function 隐藏状态栏(v)
  Trime.getService().onOptionChanged2("_hide_candidate", true)  --能防止键盘出现跳动，实际没改变_hide_candidate的值，但是键盘会有变化
  v.getLayoutParams().height = getTotalKeyboardHeight()
  Rime.setOption("_hide_candidate",true)
end

-- 恢复状态栏
function 恢复状态栏()
  Trime.getService().onOptionChanged2("_hide_candidate", hide_candidate)  --能防止键盘出现跳动，实际没改变_hide_candidate的值，但是键盘会有变化
  Rime.setOption("_hide_candidate",hide_candidate)
end