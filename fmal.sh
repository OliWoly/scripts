#!/bin/bash
# Oliwier Kulczycki

directory=$1
xattr -d com.apple.quarantine "$directory"

if [[ $# < 1 || $# > 1 ]];
then
    echo "Use one argument only."
    echo "Provide the file path to the program, to fix malware warning."
fi
