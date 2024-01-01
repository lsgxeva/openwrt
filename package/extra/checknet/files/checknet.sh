#!/bin/sh
#filename: checknet.sh

VERSION="v1.0.5-20220315"
TAGNAME="checknet"

#LOGG_STYLE="tty"
#LOGG_STYLE="file"
LOGG_STYLE="logger"
#LOGG_STYLE="tty+logger"
# RemoteLog=`uci get system.@system[0].remote_log_ip`
# if [ "$RemoteLog" != "0.0.0.0" ];then
	# LOGG_STYLE="file+logger"
# fi

LOGFILE_PATH="/tmp"
LOGFILE_NAME="checknet.log"
LOG_ENABLED=1

logg()
{
	[ $LOG_ENABLED -ne 1 ] && return 0
	if [ "$LOGG_STYLE" == "file" ]; then
		echo "$*" >> ${LOGFILE_PATH}/${LOGFILE_NAME}
	elif [ "$LOGG_STYLE" == "logger" ]; then
		echo "$*" | logger -s -p user.debug -t ${TAGNAME}
	elif [ "$LOGG_STYLE" == "tty+logger" ]; then
		echo "$*" > /dev/ttyS1
		echo "$*" | logger -s -p user.debug -t ${TAGNAME}
	elif [ "$LOGG_STYLE" == "file+logger" ]; then
		echo "$*" >> ${LOGFILE_PATH}/${LOGFILE_NAME}
		echo "$*" | logger -s -p user.debug -t ${TAGNAME}
	else
		echo "$*" > /dev/ttyS1
	fi
	return 0
}

### 

# Global Variable Definition 
DISABLED=1
SECOND=10
RESPAWN=1
LOG_ENABLED=0
WAN_ZONE='wan'
LTE1_ZONE='lte1'
LTE2_ZONE='lte2'
WAN_IFNAME='eth1'
LTE1_IFNAME='wwan0'
LTE2_IFNAME='wwan1'
MODEM_DEV1='cdc-wdm0'
MODEM_DEV2='cdc-wdm1'
MODEM_DIAL='quectel-CM'
DIAL_APN_CMNET='cmnet'
DIAL_APN_CMTDS='3gnet'
DIAL_APN_CTLTE='ctnet'
TTYUSB_AT1='ttyUSB2'
TTYUSB_AT2='ttyUSB6'


create_checknet_config()
{
	touch /etc/config/checknet
	cat /dev/null > /etc/config/checknet
	uci -q batch <<-EOF >/dev/null
		delete checknet.@checknet[0]
		add checknet checknet
		set checknet.@checknet[-1].disabled='1'
		set checknet.@checknet[-1].second='10'
		set checknet.@checknet[-1].respawn='1'
		set checknet.@checknet[-1].log_enabled='0'
		set checknet.@checknet[-1].wan_zone='wan'
		set checknet.@checknet[-1].lte1_zone='lte1'
		set checknet.@checknet[-1].lte2_zone='lte2'
		set checknet.@checknet[-1].wan_ifname='eth1'
		set checknet.@checknet[-1].lte1_ifname='wwan0'
		set checknet.@checknet[-1].lte2_ifname='wwan1'
		set checknet.@checknet[-1].modem_dev1='cdc-wdm0'
		set checknet.@checknet[-1].modem_dev2='cdc-wdm1'
		set checknet.@checknet[-1].modem_dial='quectel-CM'
		set checknet.@checknet[-1].dial_apn_cmnet='cmiotnbdtdz.zj'
		set checknet.@checknet[-1].dial_apn_cmtds='zjcyhlw01s.njiot'
		set checknet.@checknet[-1].dial_apn_ctlte='public.vpdn'
		set checknet.@checknet[-1].ttyusb_at1='ttyUSB2'
		set checknet.@checknet[-1].ttyusb_at2='ttyUSB6'
		commit checknet
	EOF
}

get_checknet_config()
{
	DISABLED=$( uci get checknet.@checknet[-1].disabled )
	SECOND=$( uci get checknet.@checknet[-1].second )
	RESPAWN=$( uci get checknet.@checknet[-1].respawn )
	LOG_ENABLED=$( uci get checknet.@checknet[-1].log_enabled )
	WAN_ZONE="$( uci get checknet.@checknet[-1].wan_zone )"
	LTE1_ZONE="$( uci get checknet.@checknet[-1].lte1_zone )"
	LTE2_ZONE="$( uci get checknet.@checknet[-1].lte2_zone )"
	WAN_IFNAME="$( uci get checknet.@checknet[-1].wan_ifname )"
	LTE1_IFNAME="$( uci get checknet.@checknet[-1].lte1_ifname )"
	LTE2_IFNAME="$( uci get checknet.@checknet[-1].lte2_ifname )"
	MODEM_DEV1="$( uci get checknet.@checknet[-1].modem_dev1 )"
	MODEM_DEV2="$( uci get checknet.@checknet[-1].modem_dev2 )"
	MODEM_DIAL="$( uci get checknet.@checknet[-1].modem_dial )"
	DIAL_APN_CMNET="$( uci get checknet.@checknet[-1].dial_apn_cmnet )"
	DIAL_APN_CMTDS="$( uci get checknet.@checknet[-1].dial_apn_cmtds )"
	DIAL_APN_CTLTE="$( uci get checknet.@checknet[-1].dial_apn_ctlte )"
	TTYUSB_AT1="$( uci get checknet.@checknet[-1].ttyusb_at1 )"
	TTYUSB_AT2="$( uci get checknet.@checknet[-1].ttyusb_at2 )"
}


###

exec_ifup_zone()
{
	local zone
	if [ $# -ne 1 ]; then
		return 1
	fi
	zone=$1
	[ -z $zone ] && logg " exec_ifup_zone - interface $zone is null" && return 1
	if [ "$( uci get network.${zone} 2>/dev/null )" == "interface" ]; then
		logg "* exec_ifup_zone - interface $zone have exist, will ifup $zone"
		#ubus call network.interface.$zone up >/dev/null 2>&1 && logg "* exec_ifup_zone - ubus interface $zone up"
		#sleep 1
		ifup $zone >/dev/null 2>&1 && logg "* exec_ifup_zone - ifup interface $zone up"
		sleep 1
	else
		logg "* exec_ifup_zone - interface $zone is not exist, will no ifup"
	fi
	return 0
}

sim_to_apn()
{
	local lte_at defaultapn
	if [ $# -ne 1 ]; then
		echo ""
		return 1
	fi
	lte_at=$1
	[ -c /dev/${lte_at} ] || return 1
	#
	# Note: Only supports gl-ar300m16 with three WANs
	# cmnet => cmiotnbdtdz.zj
	# cmtds => zjcyhlw01s.njiot
	# ctlte => public.vpdn
	#
	#[ "$( cat /tmp/sysinfo/board_name )" != "${BOARD_NAME}" ] && echo "" && return 1
	defaultapn="$( comgt -d /dev/$lte_at -s /etc/gcom/defaultapn.gcom 2>/dev/null )"
	case "$defaultapn" in 
		"cmnet"|"CMNET") 
			echo "$DIAL_APN_CMNET"
			return 0
			;;
		"cmtds"|"CMTDS") 
			echo "$DIAL_APN_CMTDS"
			return 0
			;;
		"ctlte"|"CTLTE") 
			echo "$DIAL_APN_CTLTE"
			return 0
			;;
		*) 
			echo ""
			return 1
			;;
	esac
}

dev_to_at()
{
	local lte_dev
	if [ $# -ne 1 ]; then
		echo ""
		return 1
	fi
	lte_dev=$1
	[ -c /dev/${lte_dev} ] || return 1
	#
	# Note: Only supports gl-ar300m16 with three WANs
	# cdc-wdm0 => ttyUSB2
	# cdc-wdm1 => ttyUSB6
	#
	#[ "$( cat /tmp/sysinfo/board_name )" != "${BOARD_NAME}" ] && echo "" && return 1
	case "$lte_dev" in  
		"$MODEM_DEV1") 
			echo "$TTYUSB_AT1"
			return 0
			;;
		"$MODEM_DEV2") 
			echo "$TTYUSB_AT2"
			return 0
			;;
		*) 
			echo ""
			return 1
			;;
	esac
}

zone_to_phy()
{
	local zone
	if [ $# -ne 1 ]; then
		echo ""
		return 1
	fi
	zone=$1
	#
	# Note: Only supports gl-ar300m16 with three WANs
	# wan => eth0
	# lte1 => wwan0
	# lte2 => wwan1
	#
	#[ "$( cat /tmp/sysinfo/board_name )" != "${BOARD_NAME}" ] && echo "" && return 1
	case "$zone" in  
		"$WAN_ZONE") 
			echo "$WAN_IFNAME"
			return 0
			;;
		"$LTE1_ZONE") 
			echo "$LTE1_IFNAME"
			return 0
			;;
		"$LTE2_ZONE") 
			echo "$LTE2_IFNAME"
			return 0
			;;
		*) 
			echo ""
			return 1
			;;
	esac
}

phy_to_zone()
{
	local phy
	if [ $# -ne 1 ]; then
		echo ""
		return 1
	fi
	phy=$1
	#
	# Note: Only supports gl-ar300m16 with three WANs
	# eth0 => wan
	# wwan0 => lte1
	# wwan1 => lte2
	#
	#[ "$( cat /tmp/sysinfo/board_name )" != "${BOARD_NAME}" ] && echo "" && return 1
	case "$phy" in  
		"$WAN_IFNAME") 
			echo "$WAN_ZONE"
			return 0
			;;
		"$LTE1_IFNAME") 
			echo "$LTE1_ZONE"
			return 0
			;;
		"$LTE2_IFNAME") 
			echo "$LTE2_ZONE"
			return 0
			;;
		*) 
			echo ""
			return 1
			;;
	esac
}

modem_dial_run()
{
	local proc ifname apn
	if [ $# -eq 0 ]; then
		return 1
	elif [ $# -eq 1 ]; then
		proc=$1
	elif [ $# -eq 2 ]; then
		proc=$1
		ifname=$2
	elif [ $# -eq 3 ]; then
		proc=$1
		ifname=$2
		apn=$3
	fi

	[ -z "$proc" ] && logg "* modem_dial_run - proc is null, will exit" && return 1
	[ -z "$ifname" ] && logg "* modem_dial_run - ifname is null, will exit" && return 1
	#
	# Note: Only supports quectel-CM dail
	#
	if [ -z "$apn" ]; then
		logg "* modem_dial_run - apn is null, will start dial proc"
		${proc} -i ${ifname} >/dev/null 2>/dev/null & 
	else
		logg "* modem_dial_run - apn is ${apn}, will start dial proc"
		${proc} -i ${ifname} -s ${apn} >/dev/null 2>/dev/null & 
	fi
	return 0
}

fix_modem_dial()
{
	local lte_dev lte_at dial_proc dial_apn dev_path dev_ifname proc_count zone ifip gateway 
	if [ $# -ne 1 ]; then
		return 1
	fi
	lte_dev=$1
	[ -c /dev/${lte_dev} ] || return 1
	lte_at="$( dev_to_at $lte_dev )"
	[ $? -ne 0 ] && logg "* fix_modem_dial - dev_to_at return err" && return 1
	dial_apn="$( sim_to_apn $lte_at )"
	#[ $? -ne 0 ] && logg "* fix_modem_dial - sim_to_apn return err" && return 1
	dev_path="$(readlink -f /sys/class/usbmisc/$lte_dev/device/)"
	dev_ifname="$( ls "$dev_path"/net )"
	zone="$( phy_to_zone $dev_ifname )"
	dial_proc=$MODEM_DIAL
	logg "* fix_modem_dial - lte_dev:${lte_dev}, lte_at:${lte_at}, dial_apn:${dial_apn}, dev_ifname:${dev_ifname}"
	proc_count="$( ps | grep "${dial_proc}" | grep "${dev_ifname}" | grep -v grep | wc -l )"
	if [ $proc_count -eq 0 ]; then
		logg "* fix_modem_dial - proc not running, will start dial proc"
		modem_dial_run ${dial_proc} ${dev_ifname} ${dial_apn}
		sleep 1
	elif [ $proc_count -eq 1 ]; then
		ifip="$( ifstatus $zone | jsonfilter -q -e '@["ipv4-address"][0].address' )"
		gateway="$( ifstatus $zone | jsonfilter -q -e '@["route"][0].nexthop' )"
		if [ -z "$ifip" -o -z "$gateway" ]; then
			logg "* fix_modem_dial - proc interface ip/gw is null, will restart dial proc"
			ps | grep "${dial_proc}" | grep "${dev_ifname}" | grep -v grep  | awk '{print $1}' | xargs kill -s 9 2>/dev/null
			sleep 1
			modem_dial_run ${dial_proc} ${dev_ifname} ${dial_apn}
			sleep 1
		fi
		logg "* fix_modem_dial - proc no need fixed, please show dial proc status "
	else
		logg "* fix_modem_dial - proc running exception, will restart dial proc "
		ps | grep "${dial_proc}" | grep "${dev_ifname}" | grep -v grep  | awk '{print $1}' | xargs kill -s 9 2>/dev/null
		sleep 1
		modem_dial_run ${dial_proc} ${dev_ifname} ${dial_apn}
		sleep 1
	fi
	return 0
}

fix_zone_route()
{
	local zone phy gateway_count gateway_metric
	if [ $# -ne 1 ]; then
		return 1
	fi
	zone=$1
	phy="$( zone_to_phy ${zone} )"
	[ -z "$phy" ] && logg " fix_zone_route - $zone interface is not exist" && return 1
	gateway_count=$( route -n | grep "0.0.0.0.*0.0.0.0" | grep UG | awk '{print $NF}' | grep ${phy} | wc -l )
	if [ $gateway_count -eq 0 ]; then
		logg "* fix_zone_route - default gateway $phy count is 0, will ifup $zone"
		exec_ifup_zone $zone
	elif [ $gateway_count -eq 1 ]; then
		gateway_metric=$( route -n | grep "0.0.0.0.*0.0.0.0" | grep UG | grep ${phy} | awk '{print $5}' )
		[ $gateway_metric -eq 0 ] && exec_ifup_zone $zone && 
			logg "* fix_zone_route - default gateway $phy metric is 0, will ifup $zone"
	else
		logg "* fix_zone_route - default gateway $phy count is error, will ifup $zone"
		exec_ifup_zone $zone
	fi
}

get_signal_strength()
{
	local lte_at lte_asu lte_rssi
	if [ $# -ne 1 ]; then
		return 1
	fi
	lte_at=$1
	[ ! -c "/dev/${lte_at}" ] && return 1
	lte_asu=$(comgt -d /dev/${lte_at} sig 2>/dev/null | grep "Signal Quality: " | sed "s/Signal Quality: //" | awk -F '\,' '{print $1}')
	[ -z "$lte_asu" ] && lte_asu=0
	if [ $lte_asu -ge 99 ]; then
		lte_rssi=-113
	elif [ $lte_asu -le 0 ]; then
		lte_rssi=-113
	else
		lte_rssi=$(( -113 + lte_asu * 2 ))
	fi
	logg "* get_signal_strength - lte_at=${lte_at}, lte_asu=${lte_asu}, lte_rssi=${lte_rssi}dBm "
	return 0
}


### ( Main )
# TODO: 
#   * 
#

checknet_main()
{
	[ -f "/etc/config/checknet" ] || create_checknet_config 
	[ -f "/etc/config/checknet" ] && get_checknet_config 
	[ ${DISABLED} -eq 1 ] && logg "* checknet_main - service disable, will be exit. " && return 0
	sleep 1
	[ -c /dev/${TTYUSB_AT1} ] && get_signal_strength $TTYUSB_AT1
	[ -c /dev/${TTYUSB_AT2} ] && get_signal_strength $TTYUSB_AT2
	sleep 3
	[ -c /dev/${MODEM_DEV1} ] && fix_modem_dial $MODEM_DEV1
	[ -c /dev/${MODEM_DEV2} ] && fix_modem_dial $MODEM_DEV2
	sleep 5
	[ "$( uci get network.${WAN_ZONE} 2>/dev/null )" == "interface" ] && fix_zone_route $WAN_ZONE 
	[ "$( uci get network.${LTE1_ZONE} 2>/dev/null )" == "interface" ] && fix_zone_route $LTE1_ZONE 
	[ "$( uci get network.${LTE2_ZONE} 2>/dev/null )" == "interface" ] && fix_zone_route $LTE2_ZONE 
	sleep 1
	return 0
}


SECOND=10
[ $# -eq 1 ] && SECOND=$1
while true
do
	checknet_main
	sleep $SECOND
done

exit 0

### ( End )

