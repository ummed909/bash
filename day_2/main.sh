#!/bin/bash

# Task 1: Display All Data (with a custom separator)
# awk -F',' '{print NR $1 ":" $2}' sales_data.csv

# Task 2: Extract Product Name and Unit Price

# Task 3: Filter by Category (Electronics)
# awk -F ',' '$2 == "Electronics" {print}' sales_data.csv

# Task 4: Find High-Value Sales (Unit Price > 100)
# awk -F ',' '$3 > 100 {print} ' sales_data.csv

# Task 5: Calculate Total Quantity Sold for Electronics
awk -F ',' '$2 == "Electronics" {total_qty += $4} END {print "Total" , total_qty} ' sales_data.csv

# Task 6: Reorder and Format Output
awk -F',' '{print $1 " (" $2 "): $" $3 " - Quantity: " $4}' sales_data.csv

# Task 7: Add a Header to the Output
awk -F',' '
BEGIN { # This block runs once before processing any lines
    print "Product (Category): Price - Quantity"
    print "------------------------------------" # Optional separator
}
{ # This block runs for every line
    print $1 " (" $2 "): $" $3 " - Quantity: " $4
}' sales_data.csv