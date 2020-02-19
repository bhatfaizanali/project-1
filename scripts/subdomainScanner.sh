#Usage: sh subdomainScanner.sh target.com username
#=================================================


touch crt wayback hackertarget certspotter threatcrowd virustotal
echo 'Crt.sh API'
curl -s -X GET "https://crt.sh/?q=%.$1&output=json" | jq '.[].name_value' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > crt
echo 'Wayback API'
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq > wayback
echo 'hackertarget API'
curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | cut -d',' -f1 | sort -u > hackertarget
echo 'CertSpotter API'
curl -s "https://certspotter.com/api/v0/certs?domain=$1" | jq -r '.[] | .dns_names | .[]' | sort -u > certspotter
echo 'Virtutotal API'
curl -s "https://www.virustotal.com/ui/domains/$1/subdomains" | jq '.data | .[].id' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > virustotal

#Summing Up
echo "";
cat crt wayback hackertarget certspotter threatcrowd virustotal | sort -u > ../database/$2/$1/subdomains/subdomains.txt
rm crt wayback hackertarget certspotter threatcrowd virustotal

#Copying Live Subdomains to liveSubdomains.txt
cat ../database/$2/$1/subdomains/subdomains.txt | ~/go/bin/httprobe | tee ../database/$2/$1/subdomains/liveSubdomains.txt

#Removing protocol Handlers from live subdomains
cat ../database/$2/$1/subdomains/liveSubdomains.txt | sed 's/http:\/\///g' | sed 's/https:\/\///g' | tee ../database/$2/$1/subdomains/liveSubdomainsWithoutHandlers.txt