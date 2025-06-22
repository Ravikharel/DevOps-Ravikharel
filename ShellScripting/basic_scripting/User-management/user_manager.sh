#!/bin/bash 

if [[ $EUID -ne 0 ]]; then
	echo "Please run as a root"
	exit 1
fi

while true; do 
	echo "------------------------------"
	echo "     User Management Tool     "
	echo "------------------------------"
    	echo "1. Add User"
    	echo "2. Delete User"
    	echo "3. Lock User"
    	echo "4. Unlock User"
    	echo "5. List All Users"
    	echo "6. Exit"
    	echo "------------------------------"

	read -p "Enter your choice [1-6]: " choice
	

	case $choice in 
		1)
			read -p "Enter the username:" username
			if [[ "$username" == "root" ]]; then
				echo "cannot perform this operation"
				exit 1
			fi
			if id "$username" &>/dev/null; then
				echo "user '$username' already exists!"
			else
				useradd "$username"
				echo "User "$username" added Sucessfully"

			fi
			;;
		2)
			read -p "Enter the username:" username
			if [[ "$username" == "root" ]]; then
                                echo "cannot perform this operation"
                                exit 1
                        fi
			if id "$username" &>/dev/null; then
				userdel "$username"
				echo "User '$username' is deleted Sucessfully!"
			else
				echo "user '$username' does not exit"
			fi
			;;
		3)

			read -p "Enter the username to Lock:" username
			if id "$username" &>/dev/null; then
				usermod -L "$username" && echo "User '$username' is locked"
			else
				echo "user '$username' does not exit"
		 	fi 
			;;
		4)
			read -p "Enter the username to UnLock:" username
                        if id "$username" &>/dev/null; then
                                usermod -U "$username" && echo "User '$username' is Unlocked"
                        else
                                echo "user '$username' does not exit"
                        fi
                        ;;

		5)
			echo "All users:"
			cut -d: -f1 /etc/passwd
			;;

		6)
			echo "exiting...."
			break
			;;
		*)
			echo "Invalid choice!!"
			;;
	esac
	echo ""

done


