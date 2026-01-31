require "import"
import "com.osfans.trime.*" --载入包

local function 切换方案(a)
	if a==1 then
		local 方案组=Rime.getSchemaNames() --返回输入法方案组
		--print(方案组[0])
		if #方案组==1 then
			print("当前只有1个方案,无法切换,请保证有两个方案")
			return --退出
		end
		local 方案编号=Rime.getSchemaIndex()
		local 切换编号=0
		if 方案编号==0 then 切换编号=1 end
			local 结果=Rime.selectSchema(切换编号)
				--print(方案组[切换编号])
			Rime.selectSchema(切换编号)
		if 结果==false then print("方案切换失败,请保证有两个方案") end
	end
end
切换方案(1)