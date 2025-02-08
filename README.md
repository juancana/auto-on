##  Usage

  	./auto-on.sh [OPTIONS]

####  Options

	-h	Display this help message
	-a	Shutdown system after programming wakealarm
	-t	Time in hours
 	-m	Time in minutes
	-y	Do not ask for confirmation

       
####  Examples
  
  	auto-on.sh -a -t 1 -m 30    Shutdown and wake in 1h30m
	auto-on.sh -t 5             Wake in 5h (computer stays on until manually shut down)



####  Automate with crontab

	sudo cp auto-on.sh /root/bin/
	sudo crontab -e

	[Customize and add line/s]
	30 23 * * 1-5 /root/bin/auto-on.sh -a -t 8 -m 30 -y
	0 2 * * 0,6 /root/bin/auto-on.sh -a -t 7 - y
