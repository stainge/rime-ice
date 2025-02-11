--[[
--无障碍版专用脚本
--用途：快捷加词
--如何使用: 请参考群文件，路径[同文无障碍LUA脚本]->同文无障碍版lua脚本使用说明.pdf
--配置说明

第①步 将 快捷加词.lua 文件放置 rime/script 文件夹内

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
preset_keys:
  yjjc_lua: {label: 快捷加词, send: function, command: '快捷加词.lua', option: "《《命令行》》【【词库名.txt】】"}#词库名称为自定义项
向任意按键加入上述按键既可

]]
require "import"
import "android.widget.*"
import "android.view.*"
import "java.io.File"


local 参数=(...)
local 词库文件名="flypy_user.txt"
if 参数!=nil && string.find(参数,"《《命令行》》")!=nil then
	 词库文件名 = utf8.sub(参数, 10, -3)
end
local 词库文件路径=tostring(service.getLuaDir("")).."/"..词库文件名

local function 刷新方案()
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

local function 写入词库(字符串,词库文件)
	io.open(词库文件,"a+"):write("\n"..字符串..""):close()
	Toast.makeText(service," 词组【"..字符串.."】 添加成功",2000).show()
	刷新方案()
end

layout={
    LinearLayout,
    orientation="vertical",
    {
        LinearLayout,
        layout_width="fill",
        orientation="horizontal",
        layout_height="145",
        gravity="center",
        {
            Button,
            id="citiao",
            text="词条 ：",
            layout_weight="1",
            },
        {
            EditText,
            id="edit",
            layout_weight="20",
            Hint="请在此处输入词条",
            singleLine=true,        --设置单行输入
            }
        },
    {
        LinearLayout,
        layout_width="fill",
        orientation="horizontal",
        layout_height="145",
        gravity="center",
        {
            Button,
            id="bianma",
            text="编码 ：",
            layout_weight="1",
            },
        {
            EditText,
            id="edit2",
            layout_weight="20",
            Hint="请在此处输入编码",
            singleLine=true,        --设置单行输入
            }
        },
    {
        LinearLayout,
        layout_width="fill",
        orientation="horizontal",
        layout_height="145",
        gravity="center",
        {
            Button,
            id="quxiao",
            text="取消",
            layout_weight="1",
            },
        {
            Button,
            id="queding",
            text="确定",
            layout_weight="1",
            }
        }
    }



local dl=LuaDialog(service)
.setTitle("快捷加词☞【【"..词库文件名.."】】")
.setView(loadlayout(layout))
dl.show()
dialog=dl.show()


queding.onClick=function()
  local 词条和编码=edit.getText().toString().."\t"..edit2.getText().toString()
  写入词库(词条和编码,词库文件路径)
  dialog.dismiss()
end

quxiao.onClick=function()
  print("取消")
  dialog.dismiss()
end
