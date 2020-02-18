#Usage: sh OnlinerSubdomainEnum.sh target.com
#============================================


touch crt wayback hackertarget certspotter threatcrowd virustotal


echo "\e[1;32mOneliner Subdomain Enumeration\e[0m";
echo "";

echo "\e[1;32m[!] Searching crt.sh... \e[0m";
curl -s -X GET 'https://crt.sh/?q=%.$1&output=json' | jq '.name_value' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > crt



echo "\e[1;32m[!] Searching Wayback Machine... \e[0m";
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq > wayback



echo "\e[1;32m[!] Searching Hackertarget... \e[0m";
curl -s https://api.hackertarget.com/hostsearch/?q=$1 | cut -d',' -f1 | sort -u > hackertarget




echo "\e[1;32m[!] Searching CertSpotter... \e[0m";
curl -s https://certspotter.com/api/v0/certs?domain=$1 | jq -r '.[] | .dns_names | .[]' | sort -u > certspotter




echo "\e[1;32m[!] Searching ThreatCrowd... \e[0m";
curl -s https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | jq -r '.subdomains | .[]' | sort -u > threatcrowd




echo "\e[1;32m[!] Searching VirusTotal... \e[0m";
curl -s https://www.virustotal.com/ui/domains/$1/subdomains | jq '.data | .[].id' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u > virustotal



#Summing Up
echo "";
cat crt wayback hackertarget certspotter threatcrowd virustotal | sort -u > subdomains.txt
rm crt wayback hackertarget certspotter threatcrowd virustotal
echo "\e[1;34m[!] Subdomains Found: $(wc -l subdomains.txt | sed 's/subdomains.txt//') \e[0m";
echo "\e[1;34m[!] Output File: Subdomains.txt \e[0m";
