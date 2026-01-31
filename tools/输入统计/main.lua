require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "cjson"
--activity.setTitle('AndroLua+')
--activity.setTheme(android.R.style.Theme_Holo_Light)
activity.setContentView(loadlayout(layout))
local path=activity.getLuaExtPath("data.json")
local data=cjson.decode(io.readall(path))
local adapter=list.adapter
adapter.clear()
local schema=data.schema
local key=data.key
local char=data.text
local t={}
for k,v pairs(schema)
  adapter.add(v.name)
  table.insert(t,k)
end

function getallkey(t)
  local n=0
  for k,v pairs(t)
    n=v+n
  end
  return n
end
function getallchar(t)
  local n=0
  for k,v pairs(t)
    n=v*tonumber(k)+n
  end
  return n
end


list.onItemClick=function(l,v,i,p)
  local kn=tointeger(getallkey(key[t[p]]))
  local cn=tointeger(getallchar(char[t[p]]))
  local tm=schema[t[p]].time
  activity.newActivity("showkey",{v.text,HashMap(key[t[p]]),kn,string.format([[
按键次数:%d
输入字数:%d
使用时间:%s]],kn,cn,os.date("!%H:%M:%S",tointeger(tm/1000)))})
end