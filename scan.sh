#!/bin/bash

# scan.sh - automation of running scan of host file
USAGE="""
scan.sh - automation of running scan of hosts file\n
USAGE: scan.sh HOSTS_FILE_PATH\n
Script will enumerate active subdomains and screenshot them
"""

HOSTS_FILE=$1
OUTPUT_DIR=$(printenv RECON)
SUBDOMAINS_FILE_PATH="$OUTPUT_DIR/subdomains.txt"
ACTIVE_FILE_PATH="$OUTPUT_DIR/active.txt"

# Check if argument was provided
if [[ $# -eq 0 ]]; then
	echo -e "$USAGE"
	exit 1
fi

# Check of hosts file exists
if  [ ! -f "$HOSTS_FILE" ]; then
    echo "File $HOSTS_FILE not found" >&2
    echo -e "$USAGE"
    exit 1
fi

# Gather subdomains
subfinder -dL "$HOSTS_FILE" -o "$OUTPUT_DIR/subfinder.txt" >> "$SUBDOMAINS_FILE_PATH"
amass enum -df "$HOSTS_FILE" -active -o "$OUTPUT_DIR/amass.txt" >> "$SUBDOMAINS_FILE_PATH"

# Filter only active subdomains
echo "Filtering and extracting active domains"
cat "$SUBDOMAINS_FILE_PATH" | sort | uniq | httprobe > "$ACTIVE_FILE_PATH"

# screenshot all active ones
cat" $ACTIVE_FILE_PATH" | aquatone
