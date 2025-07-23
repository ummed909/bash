#!/bin/bash

# Task 1: find all the error message
grep -in "error" server.log >> error_log.log

# Task 2: find all the critical messages
grep -in "critical" server.log

echo "-------------------------"

# Task 3: find all the loggedi n/logged out
grep -i -E "logged (in|out)" server.log

# Task 4: Investigate the database issues
grep -i -E "connection (refused|failed)" server.log

# Task 5: Indentify all the warnings and their line number
grep -in "warning" server.log >> warning_log.log

# Task 6: Extract Only the Log Level (INFO, ERROR, DEBUG, WARNING, CRITICAL)
grep -ioE "(INFO|ERROR|DEBUG|WARNING|CRITICAL)" server.log

# Task 7: Find Specific User Actions (Using Partial Matches)