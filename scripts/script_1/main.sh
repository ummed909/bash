#!/bin/bash

RAW_DATA="raw_data"
PRODUCTS="products"
USERS="users"
ORDERS="orders"
RESULT="result"



#function for logs
add_log(){
    local TYPE="${1}"
    local MESSAGE="${2}"

    echo "${TYPE} --> ${MESSAGE}" >> "logs.txt"
}

# function to create the dir

# function to filter the files
distribute(){
    local file_path=$1
    local name=$2

    if [[ $name == products_*.csv ]]; then
        mv "${file_path}"  "${RAW_DATA}/${PRODUCTS}/"
        return 0
    elif [[ $name == orders_*.csv ]]; then
        mv "${file_path}"  "${RAW_DATA}/${ORDERS}"
        return 0
    elif [[ $name == users_*.csv ]]; then
        mv "${file_path}"  "${RAW_DATA}/${USERS}"
        return 0
    else
        return 1
    fi
}

# function to load the data
load_data(){
    add_log "INFO" "Simulating data loading ...."
    local number_of_loaded_files=0
    local total_file=0
    
    for file in source/*.csv ;do
        if [ -f "${file}" ]; then
            file_name=$(basename $file)
            distribute "$file" "${file_name}"
            if [ $? -eq 0 ]; then
                add_log "INFO" "file loaded : ${file_name}"
                ((number_of_loaded_files ++))
            else
                add_log "ERROR" "${file} is skipped and Unable to load "
            fi
            (( total_file ++ ))
        fi
    done
    
    if ((number_of_loaded_files == 0)); then
        add_log "ERROR" "data loading process terminated, something went wrong "
        return 1
    else
        add_log "INOF" "data loading completed : number of files loaded ${number_of_loaded_files}/${total_file}"
        return 0
    fi
    
}




# function to porcess the data and sotre the result
process_data()
{
    add_log "INFO"  "Simulating the Data Processing"
    local number_of_product_file_processed=0
    local number_of_product_file=0
    local number_of_order_file_processed=0
    local number_of_order_file=0
    local number_of_users_file_processed=0
    local number_of_user_file=0

    #products 
    add_log "INFO" "Merging Product files ..."
    local products="${RESULT}/${PRODUCTS}.csv"
    touch $products
    for file in ${RAW_DATA}/${PRODUCTS}; do
        if [ -f $file  ]; then
            cat "${file} >> ${products}"
            add_log "INFO" "$(basename $file) is Merged Sucessfully"
            ((number_of_product_file_processed ++))
        else
            add_log "ERROR" "$(basename $file) is not merged or not found"
        fi
        ((number_of_product_file ++))
    done

    # orders
    add_log "INFO" "Merging Orders files ..."
    local orders="${RESULT}/${ORDERS}.csv"
    touch $orders
    for file in ${RAW_DATA}/${ORDERS}; do
        cat "${file} >> ${orders}"
        if [ -f $file  ]; then
            cat "${file} >> ${orders}"
            add_log "INFO" "$(basename $file) is Merged Sucessfully"
            ((number_of_order_file_processed ++))
        else
            add_log "ERROR" "$(basename $file) is not merged or not found"
        fi
        ((number_of_order_file ++))
    done

    #users
    add_log "INFO" "Merging Users files ..."
    local users="${RESULT}/${USERS}.csv"
    touch $users
    for file in ${RAW_DATA}/${USERS};do
        if [ -f $file  ]; then
            cat "${file} >> ${users}"
            add_log "INFO" "$(basename $file) is Merged Sucessfully"
            ((number_of_users_file_processed ++))
        else
            add_log "ERROR" "$(basename $file) is not merged or not found"
        fi
        ((number_of_user_file ++))
    done

    add_log "INFO" "Product FIle Processed ${number_of_product_file_processed}/${number_of_product_file}"
    add_log "INFO" "Order Files Processed ${number_of_order_file_processed}/${number_of_order_file}"
    add_log "INNO" "Users File Processed ${number_of_users_file_processed}/${number_of_user_file}"


}

# End result function

result_display(){

    local number_of_users;
    local number_of_orders;
    local number_of_product;

    
    for file in ${RAW_DATA}/*; do
        if [ -f $file ] ; then
            file_name=$(basename $file)
            if [[ $file_name == "${PRODUCTS}".csv ]]; then
                 while read -r line ;do
                     ((number_of_product ++))
                done < $file
            elif [[ $file_name == "${ORDERS}".csv ]];then
                while read -r line;do
                    ((number_of_orders ++))
                done < $file
            elif [[ $file_name == "${USERS}".csv ]];then
                while read -r line;do
                    ((number_of_users ++))
                done < $file
            fi
        fi
    done

    echo "Recoreds : Products:${number_of_product} Orders:${number_of_orders} Users:${number_of_users}"
    return 0


}

# main 

main(){
    add_log "INFO" "__________________________ Starting Scripting ____________________________________"

    mkdir -p "${PRODUCTS}"
    mkdir -p "${ORDERS}"
    mkdir -p "${USERS}"
    mkdir -p "${RAW_DATA}"
    mkdir -p "${RESULT}"


    add_log "INFO" "Loading Data ....."
    load_data

    if [ $? -eq 0 ]; then
        add_log "INFO" "Data Loaded Sucessfully"
    else
        add_log "ERROR" "Something Went Wrong in Data Loading"
        return 1
    fi

    add_log "INFO" "Processing Data ....."
    process_data
    add_log "INFO" "Data is Processed"

    add_log "INFO" "Results of Processed Data"

    local result=$(result_display)

    add_log "INFO" "${result}"

    add_log "__________________________ End of Script ____________________________________"


}

main

if [ -f "logs.txt" ]; then
    cat "logs.txt"
else
    echo "Something went wrong : No log file exist"
fi