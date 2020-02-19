#Usage: sh subdomainScanner.sh target.com username
#=================================================

cat ../database/$2/$1/subdomains/liveSubdomainsWithoutHandlers.txt | while read domain; do sslscan $domain | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g' | tee ../database/$2/$1/scandata/sslscan/$domain.sslscan;
echo "==========================================================";done
#iamfaizan
