#Usage: sh OnlinerSubdomainEnum.sh target.com
#============================================

echo $1

touch crt wayback hackertarget certspotter threatcrowd virustotal

curl -s -X GET 'https://crt.sh/?q=%.$1&output=json' | jq '.[].name_value' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > crt

curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq > wayback

curl -s https://api.hackertarget.com/hostsearch/?q=$1 | cut -d',' -f1 | sort -u > hackertarget

curl -s https://certspotter.com/api/v0/certs?domain=$1 | jq -r '.[] | .dns_names | .[]' | sort -u > certspotter

curl -s https://www.virustotal.com/ui/domains/$1/subdomains | jq '.data | .[].id' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > virustotal



#Summing Up
echo "";
cat crt wayback hackertarget certspotter threatcrowd virustotal | sort -u > subdomains.txt
rm crt wayback hackertarget certspotter threatcrowd virustotal
cat subdomains.txt

