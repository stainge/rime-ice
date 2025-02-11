--By风之曼舞
require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "android.os.*"
import "android.graphics.*"
import "com.osfans.trime.*" --载入包

local 参数=(...)
local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)





local height="320dp" --键盘高度
pcall(function()
  --键盘自适应高度，旧版中文不支持，放pcall里防报错
  height=service.getLastKeyboardHeight()
end)

local width=service.getWidth()--取键盘宽度

local 弹出布局={
  LinearLayout,
    {GridView, --列表控件
    id="list",
    numColumns=3, --6列
    layout_weight=1},
}

local data={}
local item={
          LinearLayout,
          layout_height=height/8,
          layout_width=width/8,
          {
            TextView,
            id="a",
            layout_width="50dp",
            layout_height="20dp",
            layout_gravity="center",
            layout_marginTop="0dp",
            textColor="#ff88ecc8",
            textSize="14sp",
            Gravity="center",
          },
}


弹出布局=loadlayout(弹出布局)


local adp=LuaAdapter(service,data,item)

local 字母组={"1","2","3","4","5","6","7","8","9",",","0","."}


--刷新列表
local function fresh(t)
  table.clear(data)
  for i=1,#t do table.insert(data,{a=t[i]}) end--for
  adp.notifyDataSetChanged()
end

list.Adapter=adp
fresh(字母组)



local function 对话框(v)
  local popWnd = PopupWindow(this);
  popWnd.setContentView(弹出布局);
  popWnd.setWidth(width*0.4) --设置显示宽度
  popWnd.setHeight(height*0.55) --设置显示高度
  popWnd.setOutsideTouchable(true)--点击外面区域消失
  
  --相对某个控件的位置（正左下方），无偏移
  --popWnd.showAsDropDown(v)
  --相对某个控件的位置，有偏移;xoff表示x轴的偏移，正值表示向左，负值表示向右；yoff表示相对y轴的偏移，正值是向下，负值是向上；
  --popWnd.showAsDropDown(View anchor, int xoff, int yoff)
  --相对于父控件的位置（例如正中央Gravity.CENTER，下方Gravity.BOTTOM,Gravity.TOP,Gravity.RIGHT等），可以设置偏移或无偏移
  popWnd.showAtLocation(v,Gravity.TOP, 200, 50)
end

对话框(service.getCandidateView())--候选栏弹出菜单

list.onItemClick=function(l,v,p)
  service.sendEvent(字母组[p+1])
  return true
end

