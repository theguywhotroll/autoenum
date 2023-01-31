#!/bin/bash

# Usage: bash subdomain_enumeration.sh <domain>

# Check if a domain is provided
if [ $# -eq 0 ]
then
    echo "Please provide a domain name."
    exit 1
fi

# Define the domain
domain=$1

# Create a folder to store the results
mkdir -p $domain-enumeration

# Run Amass
amass enum -d $domain -o $domain-enumeration/amass_results.txt

# Run Sublister
#sublist3r -d $domain -o $domain-enumeration/sublister_results.txt

# Run Assetfinder
assetfinder $domain >> $domain-enumeration/assetfinder_results.txt

# Run Subfinder
subfinder -d $domain -o $domain-enumeration/subfinder_results.txt

# Run Altdns
#altdns -i $domain-enumeration/amass_results.txt -o $domain-enumeration/altdns_results -r -s $domain-enumeration/altdns_results.txt

# Combine all the results into a single file
cat $domain-enumeration/*_results.txt | sort -u > $domain-enumeration/combined_results.txt

# Use httprobe on the combined results
cat $domain-enumeration/combined_results.txt | httprobe -p 80,443 -c 100 > $domain-enumeration/httprobe_results.txt
