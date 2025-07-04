read -p "Are you sure you want to add EXECUTE permission to each file in this directory? [y/N]: " answer

if [ $answer == "Y" ] | [ $answer == "y" ]
then
    sudo chmod -R +x .
    echo "Done."
else
    echo "Cancel."
fi

