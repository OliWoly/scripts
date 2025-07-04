#!/usr/bin/env bash
# Oliwier Kulczycki

# Setting file endings as strings for easier use.
endingOriginal=".HEIC"
endingIntermediate=".png"
endingFinal=".avif"




RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
CYAN=$'\033[0;36m'
CYAN_BG='\033[46m'
NC=$'\033[0m'
CLEARLINE=$'\033[K'

echo "This script is specialised on converting .HEIC images (iphone photos) to .avif."
echo "This strips the images down to and removes ${RED}HDR details${NC}, cannot find way around this."

if [ $# -eq 1 ]; then
    if [ "$1" = "." ]
    then
        # Making sure.
        echo "Batch convert:"
        directory=$(pwd "$1")
        read -p "Are you sure you want to convert all images in directory: '$directory'? [y/N]: " makeSure
        if [[ $makeSure == "y" || $makeSure == "Y" ]]; then

            fullCount=0;
            # FULL COUNT FOR COUNTER AT THE OUTPUT
            for file in "$1"/*; do
                fileEnding=$(echo "$file" | grep -oP 'IMG_.+\K\.\w+')

                if [ "${fileEnding^^}" = "${endingOriginal^^}" ]
                then
                    fullCount=$( expr $fullCount + 1 )
                fi
            done

            # Actual Algorithm
            currentCount=0
            for file in "$1"/*; do
                fileName=$(echo "$file" | grep -oP '\KIMG_\d+')
                fileEnding=$(echo "$file" | grep -oP 'IMG_.+\K\.\w+')

                if [ "${fileEnding^^}" = "${endingOriginal^^}" ]
                then
                    currentCount=$( expr $currentCount + 1 )
                    heif-convert "$fileName$fileEnding" "$fileName$endingIntermediate" > /dev/null
                    avifenc -q 53 "$fileName$endingIntermediate" "$fileName$endingFinal" > /dev/null
                    rm "$fileName$endingIntermediate"
                    echo -ne "\r${CLEARLINE}${CYAN_BG}$currentCount/$fullCount${NC} ${RED}$fileName$fileEnding ${NC}-> ${GREEN}$fileName$endingFinal${NC}"


                fi # end file ending if statement
            done


        else
            echo "Abort."
        fi  # makesure if statement
    fi      # directory batch statement
else
    echo "File Convert:"

    fileName=$(echo "$file" | grep -oP '\KIMG_\d+')
    fileEnding=$(echo "$file" | grep -oP 'IMG_.+\K\.\w+')

    echo "Starting Convert"
    heif-convert "$fileName$endingOriginal" "$fileName$endingIntermediate" > /dev/null
    avifenc -q 53 "$fileName$endingIntermediate" "$fileName$endingFinal" > /dev/null
    rm "$fileName$endingIntermediate"
    lla | grep "$fileName$endingFinal"

fi          # $#=2 if statement

