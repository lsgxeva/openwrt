#!/bin/sh
#filename: cfglte.sh

### ( Start - Auto Config wwan0 and wwan1 and mwan3 )
# network wireless firewall dhcp mwan3 checknet
#
cfg_lte()
{
	if [ -f "/etc/config/network" ]; then
		uci -q batch <<-EOF >/dev/null
			delete network.lan.ip6assign
			set network.wan.metric='33'
			delete network.wan6
			commit network
		EOF
		uci -q batch <<-EOF >/dev/null
			delete network.lte1
			add network interface
			rename network.@interface[-1]='lte1'
			set network.@interface[-1].device='wwan0'
			set network.@interface[-1].proto="dhcp"
			set network.@interface[-1].metric='31'
			commit network
		EOF
		uci -q batch <<-EOF >/dev/null
			delete network.lte2
			add network interface
			rename network.@interface[-1]='lte2'
			set network.@interface[-1].device='wwan1'
			set network.@interface[-1].proto="dhcp"
			set network.@interface[-1].metric='32'
			commit network
		EOF
	fi
	if [ -f "/etc/config/wireless" ]; then
		uci -q batch <<-EOF >/dev/null
			set wireless.default_radio0.encryption='psk2'
			set wireless.default_radio0.key='12345678'
			commit wireless
		EOF
	fi
	if [ -f "/etc/config/firewall" ]; then
		uci -q batch <<-EOF >/dev/null
			add firewall redirect
			set firewall.@redirect[-1].name='Forward2000'
			set firewall.@redirect[-1].target='DNAT'
			set firewall.@redirect[-1].src='wan'
			set firewall.@redirect[-1].dest='lan'
			set firewall.@redirect[-1].proto='tcp'
			set firewall.@redirect[-1].src_dport='2000'
			set firewall.@redirect[-1].dest_ip='192.168.111.202'
			set firewall.@redirect[-1].dest_port='2000'
			commit firewall
		EOF
		uci -q batch <<-EOF >/dev/null
			add firewall zone
			set firewall.@zone[-1].name="lte1"
			set firewall.@zone[-1].input='ACCEPT'
			set firewall.@zone[-1].forward='REJECT'
			set firewall.@zone[-1].output='ACCEPT'
			set firewall.@zone[-1].network='lte1'
			set firewall.@zone[-1].masq='1'
			set firewall.@zone[-1].mtu_fix='1'
			commit firewall
		EOF
		uci -q batch <<-EOF >/dev/null
			add firewall zone
			set firewall.@zone[-1].name="lte2"
			set firewall.@zone[-1].input='ACCEPT'
			set firewall.@zone[-1].forward='REJECT'
			set firewall.@zone[-1].output='ACCEPT'
			set firewall.@zone[-1].network='lte2'
			set firewall.@zone[-1].masq='1'
			set firewall.@zone[-1].mtu_fix='1'
			commit firewall
		EOF
		uci -q batch <<-EOF >/dev/null
			delete firewall.@forwarding[0]
			add firewall forwarding
			set firewall.@forwarding[-1].dest='wan'
			set firewall.@forwarding[-1].src='lan'
			commit firewall
		EOF
		uci -q batch <<-EOF >/dev/null
			add firewall forwarding
			set firewall.@forwarding[-1].dest='lte1'
			set firewall.@forwarding[-1].src='lan'
			commit firewall
		EOF
		uci -q batch <<-EOF >/dev/null
			add firewall forwarding
			set firewall.@forwarding[-1].dest='lte2'
			set firewall.@forwarding[-1].src='lan'
			commit firewall
		EOF
	fi
	if [ -f "/etc/config/dhcp" ]; then
		uci -q batch <<-EOF >/dev/null
			set dhcp.lan.ignore='0'
			set dhcp.wan.ignore='1'
			commit dhcp
		EOF
		uci -q batch <<-EOF >/dev/null
			delete dhcp.lte1
			add dhcp dhcp
			rename dhcp.@dhcp[-1]="lte1"
			set dhcp.@dhcp[-1].interface='lte1'
			set dhcp.@dhcp[-1].ignore='1'
			commit dhcp
		EOF
		uci -q batch <<-EOF >/dev/null
			delete dhcp.lte2
			add dhcp dhcp
			rename dhcp.@dhcp[-1]="lte2"
			set dhcp.@dhcp[-1].interface='lte2'
			set dhcp.@dhcp[-1].ignore='1'
			commit dhcp
		EOF
	fi
	if [ -f "/etc/config/mwan3" ]; then
		cat /dev/null > /etc/config/mwan3
		uci -q batch <<-EOF >/dev/null
			delete mwan3.globals
			add mwan3 globals
			rename mwan3.@globals[-1]="globals"
			set mwan3.@globals[-1].mmx_mask='0x3F00'
			set mwan3.@globals[-1].rtmon_interval='5'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.wan
			add mwan3 interface
			rename mwan3.@interface[-1]="wan"
			set mwan3.@interface[-1].enabled='1'
			set mwan3.@interface[-1].initial_state='online'
			set mwan3.@interface[-1].family='ipv4'
			add_list mwan3.@interface[-1].track_ip='223.5.5.5'
			add_list mwan3.@interface[-1].track_ip='4.2.2.1'
			add_list mwan3.@interface[-1].track_ip='10.0.0.1'
			add_list mwan3.@interface[-1].track_ip='100.64.0.1'
			set mwan3.@interface[-1].track_method='ping'
			set mwan3.@interface[-1].reliability='2'
			set mwan3.@interface[-1].count='1'
			set mwan3.@interface[-1].size='56'
			set mwan3.@interface[-1].check_quality='0'
			set mwan3.@interface[-1].timeout='3'
			set mwan3.@interface[-1].interval='5'
			set mwan3.@interface[-1].failure_interval='5'
			set mwan3.@interface[-1].recovery_interval='5'
			set mwan3.@interface[-1].down='3'
			set mwan3.@interface[-1].up='3'
			set mwan3.@interface[-1].flush_conntrack='always'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte1
			add mwan3 interface
			rename mwan3.@interface[-1]="lte1"
			set mwan3.@interface[-1].enabled='1'
			set mwan3.@interface[-1].initial_state='online'
			set mwan3.@interface[-1].family='ipv4'
			add_list mwan3.@interface[-1].track_ip='223.5.5.5'
			add_list mwan3.@interface[-1].track_ip='4.2.2.1'
			add_list mwan3.@interface[-1].track_ip='10.0.0.1'
			add_list mwan3.@interface[-1].track_ip='100.64.0.1'
			set mwan3.@interface[-1].track_method='ping'
			set mwan3.@interface[-1].reliability='2'
			set mwan3.@interface[-1].count='1'
			set mwan3.@interface[-1].size='56'
			set mwan3.@interface[-1].check_quality='0'
			set mwan3.@interface[-1].timeout='2'
			set mwan3.@interface[-1].interval='5'
			set mwan3.@interface[-1].failure_interval='5'
			set mwan3.@interface[-1].recovery_interval='5'
			set mwan3.@interface[-1].down='3'
			set mwan3.@interface[-1].up='3'
			set mwan3.@interface[-1].flush_conntrack='always'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte2
			add mwan3 interface
			rename mwan3.@interface[-1]="lte2"
			set mwan3.@interface[-1].enabled='1'
			set mwan3.@interface[-1].initial_state='online'
			set mwan3.@interface[-1].family='ipv4'
			add_list mwan3.@interface[-1].track_ip='223.5.5.5'
			add_list mwan3.@interface[-1].track_ip='4.2.2.1'
			add_list mwan3.@interface[-1].track_ip='10.0.0.1'
			add_list mwan3.@interface[-1].track_ip='100.64.0.1'
			set mwan3.@interface[-1].track_method='ping'
			set mwan3.@interface[-1].reliability='2'
			set mwan3.@interface[-1].count='1'
			set mwan3.@interface[-1].size='56'
			set mwan3.@interface[-1].check_quality='0'
			set mwan3.@interface[-1].timeout='2'
			set mwan3.@interface[-1].interval='5'
			set mwan3.@interface[-1].failure_interval='5'
			set mwan3.@interface[-1].recovery_interval='5'
			set mwan3.@interface[-1].down='3'
			set mwan3.@interface[-1].up='3'
			set mwan3.@interface[-1].flush_conntrack='always'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte1_m1_w5
			add mwan3 member
			rename mwan3.@member[-1]="lte1_m1_w5"
			set mwan3.@member[-1].interface='lte1'
			set mwan3.@member[-1].metric='1'
			set mwan3.@member[-1].weight='5'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte2_m1_w5
			add mwan3 member
			rename mwan3.@member[-1]="lte2_m1_w5"
			set mwan3.@member[-1].interface='lte2'
			set mwan3.@member[-1].metric='1'
			set mwan3.@member[-1].weight='5'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.wan_m2_w2
			add mwan3 member
			rename mwan3.@member[-1]="wan_m2_w2"
			set mwan3.@member[-1].interface='wan'
			set mwan3.@member[-1].metric='2'
			set mwan3.@member[-1].weight='2'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte_p_wan_s
			add mwan3 policy
			rename mwan3.@policy[-1]="lte_p_wan_s"
			add_list mwan3.@policy[-1].use_member='lte1_m1_w5'
			add_list mwan3.@policy[-1].use_member='lte2_m1_w5'
			add_list mwan3.@policy[-1].use_member='wan_m2_w2'
			set mwan3.@policy[-1].last_resort='default'
			commit mwan3
		EOF
		uci -q batch <<-EOF >/dev/null
			delete mwan3.lte_first
			add mwan3 rule
			rename mwan3.@rule[-1]="lte_first"
			set mwan3.@rule[-1].dest_ip='0.0.0.0/0'
			set mwan3.@rule[-1].proto='all'
			set mwan3.@rule[-1].sticky='0'
			set mwan3.@rule[-1].use_policy='lte_p_wan_s'
			commit mwan3
		EOF
	fi
	if [ -f "/etc/config/checknet" ]; then
		uci -q batch <<-EOF >/dev/null
			set checknet.@checknet[0].disabled='0'
			set checknet.@checknet[0].second='10'
			commit checknet
		EOF
	fi

	sleep 1
	/etc/init.d/network restart >/dev/null 2>&1
	sleep 1
	/etc/init.d/firewall restart >/dev/null 2>&1
	sleep 1
	/etc/init.d/dnsmasq restart >/dev/null 2>&1
	sleep 1
	/etc/init.d/mwan3 restart >/dev/null 2>&1
	sleep 1
	/etc/init.d/checknet restart >/dev/null 2>&1
	sleep 1

	return 0
}
### ( End - Auto Config wwan0 and wwan1 and mwan3 )

### ( Main )
# TODO: 
#   * 
#

if [ "$( uci get network.lte1 2>/dev/null )" == "interface" -o "$( uci get network.lte2 2>/dev/null )" == "interface" ]; then
	echo "info: config network lte already exists, will exit."
	exit 0
fi

[ -f "/tmp/cfglte-init" ] && cfg_lte && touch "/etc/cfglte-done" && echo "info: config network lte done." && exit 0

[ -f "/etc/cfglte-done" ] && echo "info: config done flag file already exists, will exit." && exit 0

if [ -d "/sys/class/net/wwan0" -o -d "/sys/class/net/wwan1" ]; then
	cfg_lte && touch "/etc/cfglte-done"
	echo "info: config network lte done."
else
	echo "info: config network lte not support."
fi

exit 0

### ( End )
