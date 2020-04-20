#!/bin/bash
USAGE="""URL Extractor splitter - for removing useless garbage from burp exported URLs and putting in a report\n
	  extract_urls.sh PATH_TO_FILE [OUTPUT_FILE_PATH]\n
	  OUTPUT_FILE_PATH: Path to the beatufied URLs
	  """
		
# TODO: add an option to add levels of URL extracting - -L/--levels

# Check if variables provided
if [ "$#" -eq 0 ]; then
  echo -e $USAGE
    exit 1
fi


INPUT_FILE=$1

# Check if file exists
if  [ ! -f "$INPUT_FILE" ]; then
	echo "File $1 not found" >&2
	exit 1
fi

if [ "$1" != "" ]; then
    echo "Extracting URLs from file $1"
    # extract files
    OUTPUT=$(cat $INPUT_FILE | cut -d '/' -f1-5 | sort | uniq)
    if [ "$2" != "" ]; then
	    PATH_TO_OUTPUT_FILE=$2
	    echo "$OUTPUT" > $PATH_TO_OUTPUT_FILE
	    echo "Extracted URLs to $PATH_TO_OUTPUT_FILE"
     else
	    echo -e "Extracted URLs: \n $OUTPUT"
    fi
fi
