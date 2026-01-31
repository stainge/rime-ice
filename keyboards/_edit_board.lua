--[[
【编辑 2.0】2023.07.23

作者：星乂尘 1416165041@qq.com

仅支持：中文输入法（同文无障碍版）

使用说明：
①本文件放入文件夹/rime/keyboards/
②主题trime.yaml
preset_keys:
  _Keyboard_edit: {label: 编辑, send: Eisu_toggle, select: _edit_board}
]]

--按键
local keys={
  {click="Page_Up",width=18},{click="copy"},{click="Up"},{click="paste"},{click="BackSpace",width=19},
  {click="undo",long_click="redo",width=18},{click="Left",swipe_up="Home",swipe_left="Home",swipe_right="End"},{click="Shift_R",swipe_left="Home",swipe_right="End",round_corner=100},{click="Right",swipe_up="End",swipe_left="Home",swipe_right="End"},{click="space",long_click="Return",width=19},
  {click="Page_Down",swipe_up="End",swipe_right="End",width=18},{click="select_all"},{click="Down"},{click="cut"},{click="Keyboard_default",width=19},
}

--键盘
local edit={name="编辑",keys=keys,
  ascii_mode=0,width=21,height=75,
  key_symbol_offset_y=1,key_press_offset_y=-6}

--判断横屏
if service.isLandscape()
  --横屏，修改键盘高度
  edit.height=56
 else
  --竖屏，增加一行隐形按键抬高键盘
  table.insert(keys,{width=100,height=5})
end

--保持Shift状态
task(9,function()
  local key=service.getKeyboardView()
  key.setShifted(true,key.isShifted())
end)

--返回键盘数据table
return edit
