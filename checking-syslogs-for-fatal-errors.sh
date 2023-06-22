#!/bin/bash

# Set path to your syslog file
SYSLOG_FILE="/var/log/syslog"

# Set path to the report file
REPORT_FILE="syslog_report.txt"

# Set critical error keywords to search for
CRITICAL_ERRORS=("error" "critical" "failure" "fatal")

# Function to search for critical errors in syslog
search_critical_errors() {
    local syslog_file="$1"
    local report_file="$2"

    # Clear the report file
    > "$report_file"

    # Loop through each critical error keyword
    for keyword in "${CRITICAL_ERRORS[@]}"; do
    
        # Use 'grep' to search for the keyword (case-insensitive) in the syslog file
        # Append the matching lines to the report filegrep -i "$keyword" "$syslog_file" >> "$report_file"
        echo "" >> "$report_file"
    done

    echo "Critical error analysis completed. Please check the report: $report_file"
}

# Execute the search_critical_errors function
search_critical_errors "$SYSLOG_FILE" "$REPORT_FILE"

