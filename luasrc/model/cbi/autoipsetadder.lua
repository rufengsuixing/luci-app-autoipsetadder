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
o.template = "autoipsetadder/check"
---- apply
local apply = luci.http.formvalue("cbi.apply")
if apply then
     io.popen("/etc/init.d/autoipsetadder reload &")
end


return mp
