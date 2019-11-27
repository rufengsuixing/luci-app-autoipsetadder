require("luci.sys")
require("luci.util")
local fs=require"nixio.fs"
local uci=require"luci.model.uci".cursor()

mp = Map("autoipsetadder", translate("ipsetautoadder"))
mp.description = translate("自动将国外联不通的域名加入ipset")
mp:section(SimpleSection).template  = "autoipsetadder/status"

s = mp:section(TypedSection, "autoipsetadder")
s.anonymous=true
s.addremove=false
---- enable
o = s:option(Flag, "enabled", translate("启用"))
o.default = 0
o.rmempty = false
---- log1
o=s:option(TextValue, "show", "日志")
o.rmempty=true
o.rows=10
o.readonly="readonly"
function o.cfgvalue()
     logfile="/tmp/addlist.log"
     if not fs.access(logfile)then
          return "no log available"
     end
     return fs.readfile(logfile)
end
o=s:option(Button,"debug",translate("debug"))
o.inputtitle=translate("debug")
o.template = "autoipsetadder/check"

local apply = luci.http.formvalue("cbi.apply")
if apply then
     io.popen("/etc/init.d/autoipsetadder reload &")
end


return mp
