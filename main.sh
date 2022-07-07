#!/usr/bin/bash

<<HI
project: DBMS <bash script>
describtion: this file represent DDl operation 
Authors: <Ismael Ramadan> .<Ahmed Abdelsalam>


this is mini version of DBMS using bash script
== about databases : you can create , list , connect  and drop databases 
== about each database : you can create , list and drop tables  
== and then finally DML -> data manipulation language 
you can 
- insert 
- select 
- update 
- delete 
from tables 
HI


echo    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo      "~~~~~~~~~< Welcome TO DBMS Using Shell Scripting >~~~~~~~~~~"
echo    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

############# MAin menu section #################

main_menu(){
    echo -e "\n  ~~~~~~~~~< choose from menu: >~~~~~~~~~~\n"
    echo "~~~~~~~<   1. Create Database       >~~~~~~~"
    echo "~~~~~~~<   2. List Databases        >~~~~~~~"
    echo "~~~~~~~<   3. Connect To Databases  >~~~~~~~"
    echo "~~~~~~~<   4. Drop Database         >~~~~~~~"
    echo -e "~~~~~~~<   5. Exit                  >~~~~~~~\n"

    read -p "Enter the Number of your choice:  " choice

    if (($choice >=1)) && (($choice <=5));then
        case $choice in 
            1) creating_db ;;
            2) list_db ;;
            3) connect_db ;;
            4) drop_db ;;
            5) exit ;;
            *) echo "Ooops! wrong input <<check again>>" main_menu
        esac
    else
        echo "Wrong input !!" 
        main_menu
    fi
}

########  creating database section #############
creating_db()
{
	read -p "Enter DB name plz:  " dbname
	if [[ "$dbname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -d "DBMS_dir/$dbname" ];then
			echo " DBname already exist !"
			creating_db
		else
			mkdir DBMS_dir/$dbname
                        echo " '$dbname' created successfully!"
                        main_menu
		fi			
	else
		echo "Enter Valid name plz:  "
		creating_db
	fi

}

######### listing tables section ################

list_db()
{      
        if [[ $(ls -A DBMS_dir) ]];then
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                ls DBMS_dir
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        else
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo -e "\nOoops. No Databases to Display " 
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

        fi
        main_menu
}

######### connect database section ##############

connect_db()
{
        read -p "Enter DB name plz:  " dbname
	if [[ "$dbname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -d "DBMS_dir/$dbname" ];then
			echo " right plz wait ! "
                        sleep 1
                        cd DBMS_dir/$dbname
			. /home/ismailramadan/DevOps/DBMS/ddl.sh 
		else
		        read -p "DB doesn't exist >> creat new ? [y|n] " ch 
                        case $ch in 
                                y) creating_db ;;
                                n) main_menu ;;
                                *) exit ;;
                        esac
		fi			
	else
		echo "Enter Valid name plz;"
		connect_db
	fi
}

########## dropping database section ############

drop_db()
{
        read -p "Enter DB name plz: " dbname
	if [[ "$dbname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -d "DBMS_dir/$dbname" ];then
                        rm -rf DBMS_dir/$dbname 
                        echo " ' $dbname ' Dropped successfully !"
                        main_menu       
		else
                        echo "DB doesn't exist !"
                        main_menu
		fi			
	else
		echo "Enter Valid name plz:  "
		drop_db
	fi
}


#############
main_menu
###########