#!/bin/sh
dlchina=$1;
ipset list gfwlist | awk -v dlchina="$dlchina" '{
if (index($0,".")==0)
{
    next;
}
"ipset test whitelist "$0" 2>&1"| getline ipset;
close("ipset test whitelist "$0" 2>&1");
    if (index(ipset,"Warning")==0){
        white=0;
    }else{
        white=1;
    }
    "ipset test china "$0" 2>&1"| getline ipset;
    close("ipset test china "$0" 2>&1");
    if (index(ipset,"Warning")!=0){
        china=1;
    }
    else{
        china=0;
    }
    if (white==1)
    {
        if (china==0)
        {
        print("warning white ip not china"$0);
        ret=system("grep "$0" /tmp/nohup.out");
        if (ret!=0)
        {
            ret=system("grep "$0" /tmp/dnsmasq.log");
        }
        }
    }else if (china==1)
	{
		print("warning china ip not white"$0);
		ret=system("grep "$0" /tmp/nohup.out")
		if (ret!=0)
		{
			ret=system("grep "$0" /tmp/dnsmasq.log");
		}
		if (dlchina)
		{
			system("ipset del gfwlist "$0);
		}
	}  
}'