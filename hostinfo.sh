#!/bin/bash					#
#						#
# Host server location information  		#
#						#
#################################################
#						#
# Version 0.2					#
#						#
#################################################

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;02m"
COL_BLUE=$ESC_SEQ"36;02m"
COL_GREEN=$ESC_SEQ"32;02m"
COL_GREY=$ESC_SEQ"38;02m"
COL_P=$ESC_SEQ"35;02m"


read -p "Host Name :: " name

ip=`host $name |grep "has address" | head --line=1 |awk {' print $4 '}`

if [ -z $ip ]; then echo -e "$COL_RED Domain $name Does Not Exist ! $COL_RESET" ;exit 0;  else echo -e "$COL_GREY Domain Check =$COL_P OK$COL_RESET"; fi

wget -qO- "https://geoip.flagfox.net/?ip=$ip&host=$name" > /tmp/raw.txt

continent=`cat /tmp/raw.txt | grep -i "target=" |head --line=2|tail -n 1 |cut -d"<" -f 3|sed 's/>/ /g'|awk {' print $2" "$3" "$4" "$5" "$6 '}`
continent=`echo -e $COL_BLUE$continent$COL_RESET`

country=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $3" "$4" "$5" "$6" "$7" "$8 '}|sed 's/, /|/g' |cut -d'|' -f 2`
country=`echo -e $COL_BLUE$country$COL_RESET`

hostname=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $1 '}`
hostname=`echo -e $COL_GREEN$hostname$COL_RESET`

region=`cat /tmp/raw.txt |grep -2 "Region</td>" |sed 's/>/ /'|sed 's/</ /g'|tail -n 1|sed 's/span//g'|sed 's/class="dim"//g'|sed 's/\/>//g'`
region=`echo -e $COL_BLUE$region$COL_RESET`

metropolis=`cat /tmp/raw.txt | grep nowrap |tail -n 1 |cut -d"<" -f 2 | sed 's/>/ /g'|awk {' print $4" "$5" "$6" "$7 '}`
metropolis=`echo -e $COL_BLUE$metropolis$COL_RESET`

city=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $3" "$4" "$5" "$6" "$7" "$8 '}|sed 's/, /|/g' |cut -d'|' -f 1`
city=`echo -e $COL_BLUE$city$COL_RESET`

isp=`cat /tmp/raw.txt |grep -2 ISP | tail -n 1|sed 's/span//g'|sed 's/class="dim"//g'|cut -d"<" -f 2|sed 's/>//g'`
isp=`echo -e $COL_BLUE$isp$COL_RESET`

postal=`cat /tmp/raw.txt |grep -2 Postal |sed 's/>/ /'|sed 's/</ /g'|tail -n 1|sed 's/span//g'|sed 's/class="dim"//g'|sed 's/\/>//g'`
postal=`echo -e $COL_BLUE$postal$COL_RESET`

latitude=`cat /tmp/raw.txt | grep -2 Latitude| tail -n 1`
latitude=`echo -e $COL_BLUE$latitude$COL_RESET`

longitude=`cat /tmp/raw.txt |grep -2 Longitude| tail -n 1`
longitude=`echo -e $COL_BLUE$longitude$COL_RESET`

ccode=`cat /tmp/raw.txt | grep -2 "Country Code"| grep "&nbsp;" | sed 's/&nbsp;/ /g'`
ccode=`echo -e $COL_BLUE$ccode$COL_RESET`

ip=`echo -e $COL_BLUE$ip$COL_RESET`


#printf "Hostname : %30%			IP Address : %30%      \n" $hostname $ip
#printf "ISP : %30%			Country Code : %30%    \n" $isp $ccode
#printf "Continent : %30%		Country : %30%         \n" $continent $country
#printf "Region : %30%    		City : %30%            \n" $region $city
#printf "Metropolis* : %30%      	Postal Code : %30%     \n" $metropolies $postal
#printf "Latitude : %30% 		Longitude : %30%       \n" $latitude $longitude
hostname="$COL_GREY Hostname$COL_RESET : ${hostname}"
ip="$COL_GREY IP Address$COL_RESET : ${ip}"
isp="$COL_GREY ISP$COL_RESET : ${isp}"
ccode="$COL_GREY Country Code$COL_RESET : ${ccode}"
continent="$COL_GREY Continent$COL_RESET : ${continent}"
country="$COL_GREY Country$COL_RESET : ${country}"
region="$COL_GREY Region$COL_RESET : ${region}"
city="$COL_GREY City$COL_RESET : ${city}"
metropolis="$COL_GREY Metropolies$COL_RESET : ${metropolis}"
postal="$COL_GREY Postal Code$COL_RESET : ${postal}"
latitude="$COL_GREY Latitude$COL_RESET : ${latitude}"
longitude="$COL_GREY Longitude$COL_RESET : ${longitude}"
echo
#echo -e -n "${hostname} |${ip} \n\n${isp} |${ccode} \n\n${continent} |${country} \n\n${region} |${city} \n\n${metropolis} |${postal} \n\n${latitude} |${longitude}" | column -c 1000 -t -s "|" 
echo -e -n "${hostname}=${ip}\n${isp}=${ccode}\n${continent}=${country}\n${region}=${city}\n${metropolis}=${postal}\n${latitude}=${longitude}" | column -c 1000 -t -s "=" 

echo

#rm -f /tmp/raw.txt

	
