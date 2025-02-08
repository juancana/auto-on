#!/bin/bash


# Default variable values
shutdown=false
minutes=0
hours=0
confirmation=true

# Function to display script usage
usage() {
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h	Display this help message"
 echo " -a 	Shutdown system after programming wakealarm"
 echo " -t	Time in hours"
 echo " -m 	Time in minutes"
 echo " -y	Do not ask for confirmation"
 echo ""
 echo "  Example:"
 echo "  	$0 -a -t 1 -m 30	Shutdown and wake in 1h30m"
 echo "  	$0 -t 5  		Wake in 5h"
 echo ""
 echo ""
 echo ""
 echo "  Automate with crontab:"
 echo ""
 echo "		sudo cp auto-on.sh /root/bin/"
 echo "		sudo crontab -e"
 echo ""
 echo "		<Customize and add line/s>"
 echo "		30 23 * * 1-5 /root/bin/auto-on.sh -a -t 8 -m 30 -y"
 echo "		0 2 * * 0,6 /root/bin/auto-on.sh -a -t 7 - y"
 echo ""
 echo ""
 echo ""
}


# Handle options and arguments
while getopts 'hat:m:y' OPTION; do
  case "$OPTION" in
    h)
     usage
     exit 0
     ;;
    a)
     shutdown=true
     ;;
    t)
     hours="$OPTARG"
     re='^[0-9]+$'
     if ! [[ $hours =~ $re ]] ; then
      echo "ERROR Invalid number of hours"
      echo""
      exit 1
     fi
     delay=0
     ;;
    m)
     minutes="$OPTARG"
     re='^[0-9]+$'
     if ! [[ $minutes =~ $re ]] ; then
      echo "ERROR Invalid number of minutes"
      echo""
      exit 1
     fi
     delay=0
     ;;
    y)
     confirmation=false
     ;;
    ?)
     echo "Invalid option."
     echo "Use $0 -h to display help menu"
     echo ""
     exit 1
     ;;
  esac
done



# Main script execution

# Calculate power on time
if [[ -z $delay ]]; then
 delay=480
 echo ""
 echo "Programming power on in 8h"
else
 delay=$(($minutes+($hours*60)))
 echo ""
 echo "Programming power on in "$hours"h "$minutes"m"
fi


# Prompt user
if [ "$confirmation" = "true" ]; then
 if [ "$shutdown" = true ]; then
  echo "  and shut down now"
 else
  echo "  but not shutdown"
 fi

 echo ""
 printf "%s " "Continue (y/N)? "
 read ans
 if [[ "$ans" != "y" ]]; then
  echo ""
  echo "Quitting..."
  echo ""
  exit 0
 fi
fi

# Program auto power on in X hours
part1="echo \`date '+%s' -d '"
part2="+ "$(printf "%d" $delay)" minutes"
command=$part1$part2"'\` > /sys/class/rtc/rtc0/wakealarm"
sh -c "$command"

if [ "$shutdown" = true ]; then
 echo ""
 echo "Shutting down..."
 echo ""
 shutdown -h now
fi
