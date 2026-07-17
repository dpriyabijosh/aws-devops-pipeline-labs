#!/bin/bash
# Check if a file path was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-log-file>"
    exit 1
fi

# grep: The global regular expression print utility - Its job is to search files for specific text matches.
# -i: The ignore case flag. It tells grep to match ERROR, error, Error, or ErRoR.
# "ERROR": The specific keyword you are searching for.
# "$1": The target file want grep to scan.
# Find errors, then use awk to print the date ($1) and time ($2)
# | (The Pipe): This tells Linux: "Do not print the matching lines to the screen yet. Hold them in memory and pass them directly to the next program."
# wc: The word count utility.
# -l: The lines flag. It tells wc to count only the total number of lines it receives, instead of characters or words.
# Step 1: grep scans the file path passed into your script ($1) and drops every line that does not contain the word "ERROR".
# Step 2 (|): The first pipe hands those filtered error lines directly to awk.
# Step 3: awk extracts columns 1 and 2 (date and time) and builds a clean phrase beginning with "Incident at:".
# Step 4: wc -l counts the lines it receives and displays the total number on your terminal.
echo "=== INCIDENT REPORT SUMMARY ==="
# 1. Print the dates and times
grep -i "ERROR" "$1" | awk '{print "Incident at: " $1, $2}'

echo "-------------------------------"
# 2. Print the total count
echo -n "Total Errors Found: "
grep -i "ERROR" "$1" | wc -l
