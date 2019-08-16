#!/bin/bash

function Judge
{
	if [[ $(prime-switch | grep Is\ nvidia\ blacklisted? | awk '{print $4}') = "no" ]]
	then
		if [[ $(prime-switch | grep Is\ nvidia\ loaded? | awk '{print $4}') = "yes" ]]
		then
			if [[ $(nvidia-smi -q | grep Processes | awk '{print $3}') = "None" ]]
			then
				Graphic="Intel"
				Graphic_sta="Nvidia"
				Start
			elif [[ $(nvidia-smi -q | grep Processes | awk '{print $3}') = "" ]]
			then
				Graphic="Nvidia"
				Graphic_sta="Nvidia"
				Start
			fi	
		fi
	elif [[ $(nvidia-smi -q | grep Processes | awk '{print $3}') = "" ]]
	then
		if [[ $(prime-switch | grep Is\ nvidia\ loaded? | awk '{print $4}') = "no" ]]
		then
			Graphic="Intel"
			Graphic_sta="Intel"
			Start
		elif [[ $(prime-switch | grep Is\ nvidia\ blacklisted? | awk '{print $4}') = "yes" ]]
		then
			Graphic="Nvidia"
			Graphic_sta="Intel"
			Start
		fi
	fi	
}
function Logout
{
	echo "是否立即执行注销？" 
	echo "回车立即注销，否则请输入：n"
	read -p "请输入：" sta1
	if [ "$sta1" == n ]
	then
		 exit
	else
		killall gdm-x-session
	fi
}
function Select
{	
	echo "》注意：设置后必须注销后才能生效！《"
	echo "切换选项：(1：Intel、2：Nvidia)"
	echo "直接回车退出操作！"
	read -p "请输入：" sta
	if [ "$sta" == "" ]
	then
		exit
	else
		case $sta in
		1) 
			if [ "$Graphic" == "Nvidia" ]
			then
				if [ "$Graphic_sta" == "Nvidia" ]
				then
					sudo prime-select intel
					echo "设置成功"
					Logout
				fi
			elif [ "$Graphic" == "Intel" ] 
			then	
				if [ "$Graphic_sta" == "Intel" ] 
				then
					echo "您当前已使用Intel显卡，无需切换！"
					exit
				fi
			fi
		;;
		2)
			if [ "$Graphic" == "Intel" ]
			then
				if [ "$Graphic_sta" == "Intel" ]
				then 
					sudo prime-select nvidia
					echo "设置成功"
					Logout
				fi
			elif [ "$Graphic" == "Nvidia" ] 
			then 
				if [ "$Graphic_sta" == "Nvidia" ]
				then
					echo "您当前已使用Nvidia显卡，无需切换！"
					exit
				fi
			fi
		;;
		*) echo "输入有误，请重试！" 
			Start
		;;
		esac
	fi
}
function Start
{	
	echo "*****本程序功能为快速切换Intel显卡与NVIDIA显卡*****"
	if [ "$Graphic" == "Intel" ]
	then
		if [ "$Graphic_sta" == "Intel" ] 
		then
			echo "**********您当前正在使用Intel显卡！**********"
		elif [ "$Graphic_sta" == "Nvidia" ]
		then 
			echo "您当前已设置启用Nvidia显卡，但未生效，需注销后启用！"z
			Logout
		fi
	else
		if [ "$Graphic" == "Nvidia" ]
		then
			if [ "$Graphic_sta" == "Nvidia" ]
			then
				echo "**********您当前正在使用Nvidia显卡！**********"
			elif [ "$Graphic_sta" == "Intel" ]
			then
				echo "您的Intel显卡已启用，但未生效，需注销后启用！"
				Logout
			fi
		fi
	fi
	Select
}
Judge

