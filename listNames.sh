#!/bin/bash

directory="$1"  # First argument is the directory

if [[ ! -d "$directory" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

for file in "$directory"/*; do
  echo "$file"
done

