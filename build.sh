#!/bin/sh

if [ $# -eq 1 -o $# -eq 0 ];then
	if [ "$1" = "clean" ];then
		make distclean
		exit 0
	fi
	make distclean
	if [ $? -ne 0 ];then
		exit
	fi
	make itop4412_defconfig
	if [ $? -ne 0 ];then
		exit
	fi
	make ARCH=arm CROSS_COMPILE=/opt/arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -j16
	if [ $? -ne 0 ];then
		exit
	fi
else
	echo "param error"
fi

if [ $# -eq 1 ];then
	if [ "$1" = "all" ];then
		./mkbl2 spl/u-boot-spl.bin bl2.bin 14336
		i=0
		while true
		do
			if [ $i -gt 10 ];then
				echo "waitting time is out"
				exit 1
			fi
			if [ "$(ls /dev/sdc)" ];then
				break
			else
				echo "/dev/sdc is not ready, retries = $i"
				i=`expr $i + 1`
				sleep 1
			fi
		done
		sudo dd iflag=dsync oflag=dsync if=E4412_N.bl1.bin of=/dev/sdc seek=1
		sudo dd iflag=dsync oflag=dsync if=bl2.bin of=/dev/sdc seek=17
		sudo dd iflag=dsync oflag=dsync if=u-boot.bin of=/dev/sdc seek=81
		sudo sync
	elif [ "$1" = "clean" ];then
		make distclean
	else
		echo "param error"
	fi
fi
