#!/bin/bash

# Function to print text in green
print_green() {
    echo -e "\033[32m$1\033[0m"
}

# Function to print text in red
print_red() {
    echo -e "\033[31m$1\033[0m"
}

# Function to check URL status
check_url() {
    url=$1
    status_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")
    if [ "$status_code" -eq 200 ]; then
        print_green "$url is up (status code: $status_code)"
    else
        print_red "$url is down or returned status code: $status_code"
    fi
}

# Function to check if a file exists locally
check_file() {
    file_path=$1
    if [ -f "$file_path" ]; then
        print_green "Local file $file_path exists."
    else
        print_red "Local file $file_path does not exist."
    fi
}

# Check if an HTML file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <html-file>"
    exit 1
fi

html_file=$1

# Extract all URLs from href attributes in the HTML file, ignoring lines containing 'data:'
urls=$(sed -n 's/.*href="\([^"]*\)".*/\1/p' "$html_file" | grep -v '^data:')

# Extract all file paths from img src attributes in the HTML file, ignoring lines containing 'data:'
img_srcs=$(sed -n 's/.*src="\([^"]*\)".*/\1/p' "$html_file" | grep -v '^data:')

# Check each URL
for url in $urls; do
    check_url "$url"
done

# Check each image file path
for img_src in $img_srcs; do
    check_file "$img_src"
done
