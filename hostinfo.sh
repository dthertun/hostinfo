#!/bin/bash					#
#						#
# Host server location information  		#
#						#
#################################################
#						#
# Version 0.1					#
#						#
#################################################

read -p "Host Name :: " name

ip=`host $name |grep "has address" | head --line=1 |awk {' print $4 '}`

wget -qO- "https://geoip.flagfox.net/?ip=$ip&host=$name" > /tmp/raw.txt

continent=`cat /tmp/raw.txt | grep -i "target=" |head --line=2|tail -n 1 |cut -d"<" -f 3|sed 's/>/ /g'|awk {' print $2" "$3" "$4" "$5" "$6 '}`

country=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $3" "$4" "$5" "$6" "$7" "$8 '}|sed 's/, /|/g' |cut -d'|' -f 2`

hostname=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $1 '}`

region=`cat /tmp/raw.txt | head --line=223 | tail -n 1`
region=`echo $region`

metropolis=`cat /tmp/raw.txt | grep nowrap |tail -n 1 |cut -d"<" -f 2 | sed 's/>/ /g'|awk {' print $4" "$5" "$6" "$7 '}`

city=`cat /tmp/raw.txt | grep $ip |tail -n 1 |sed 's/<br>/ /g'|cut -d"'" -f 2 |awk {' print $3" "$4" "$5" "$6" "$7" "$8 '}|sed 's/, /|/g' |cut -d'|' -f 1`

isp=`cat /tmp/raw.txt | head --line=177|tail -n 1`
isp=`echo $isp`

postal=`cat /tmp/raw.txt |head --line=250|tail -n 1`
postal=`echo $postal`

latitude=`cat /tmp/raw.txt |head --line=266|tail -n 1`
latitude=`echo $latitude`

longitude=`cat /tmp/raw.txt | head --line=282|tail -n 1`
longitude=`echo $longitude`

ccode=`cat /tmp/raw.txt | grep "&nbsp;" |head --line=48|tail -n 1|sed 's/&nbsp;/ /g'`
ccode=`echo $ccode`



#printf "Hostname : %30%			IP Address : %30%      \n" $hostname $ip
#printf "ISP : %30%			Country Code : %30%    \n" $isp $ccode
#printf "Continent : %30%		Country : %30%         \n" $continent $country
#printf "Region : %30%    		City : %30%            \n" $region $city
#printf "Metropolis* : %30%      	Postal Code : %30%     \n" $metropolies $postal
#printf "Latitude : %30% 		Longitude : %30%       \n" $latitude $longitude
echo
echo -e "Hostname : $hostname |IP Address : $ip \n\nISP : $isp |Country Code : $ccode \n\nContinent : $continent |Country : $country \n\nRegion : $region |City : $city \n\nMetropolies : $metropolis |Postal Code : $postal \n\nLatitude : $latitude |Longitude : $longitude" | column -t -s "|"
echo

rm -f /tmp/raw.txt

