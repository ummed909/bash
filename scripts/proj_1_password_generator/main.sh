
#!/bin/bash

SOURCE="./logs/*"

# function to creaste the distingush the logs
seprate_logs(){
    for file in $SOURCE; do
        if [ -f $file ]; then
            filename=$(basename $file)
            if [ $filename == "logfile_48.log" ]; then
                awk "{print}" "$file"
            # else
            #     echo 'none'
            fi
        fi
    done  
}

main(){

    seprate_logs

}


main
