

require "import"

function 发送广播(tab1,tab2)
  import "android.content.Intent"
  import "android.content.IntentFilter"
  import "android.content.BroadcastReceiver"
  when type(tab1)=="string" tab1={tab1}
  for k1,v1 in pairs(tab1)
    local intent= Intent(v1)
    for k,v in pairs(tab2)
      intent.putExtra(tostring(k), v)
    end
    service.sendBroadcast(intent)
  end
end

--范例
--发送广播("com.fooview.android.fooview",{Share=图片组[p+1]}) --Share是Key，可以有多个Key
