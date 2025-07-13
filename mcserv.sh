#!/bin/bash
# Oliwier Kulczycki

cd ~/Minecraft\ Servers/
directoryListing=$(ls -la)
echo "$directoryListing"

specific=$("$directoryListing" | grep -oP "\Knaked")
echo "$specific"
