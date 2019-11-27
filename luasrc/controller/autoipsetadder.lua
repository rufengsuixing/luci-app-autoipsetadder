module("luci.controller.autoipsetadder",package.seeall)
io     = require "io"
fs=require"nixio.fs"
function index()
end
	entry({"admin","services","autoipsetadder"},firstchild(),_("autoipsetadder"),30).dependent=true
	entry({"admin","services","autoipsetadder","general"},cbi("autoipsetadder"),_("Base Setting"),1)
    entry({"admin","services","autoipsetadder","status"},call("act_status")).leaf=true
	entry({"admin", "services", "autoipsetadder", "check"}, call("check_update"))
	entry({"admin", "services", "autoipsetadder", "doupdate"}, call("dodebug"))
end

function act_status()
  local e={}
  e.running=luci.sys.call("pgrep -f tail >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end
function do_update()
nixio.fs.writefile("/var/run/lucilogpos_ipset","0")
nixio.fs.writefile("/tmp/debugip","")
luci.sys.exec("(touch /var/run/debugipset ; /usr/bin/debugip.sh</tmp/debugip & ;rm /var/run/debugipset) &")
luci.http.prepare_content("application/json")
luci.http.write('')
end
function check_update()
	luci.http.prepare_content("text/plain; charset=utf-8")
	fdp=tonumber(nixio.fs.readfile("/var/run/debugipset"))
	f=io.open("/tmp/debugip", "r+")
	f:seek("set",fdp)
	a=f:read(8192)
	if (a==nil) then
	a=""
	end
	fdp=f:seek()
	nixio.fs.writefile("/var/run/lucilogpos_ipset",tostring(fdp))
	f:close()
	if nixio.fs.access("/var/run/debugipset") then
		luci.http.write(a)
	else
		luci.http.write(a.."\0")
	end
end