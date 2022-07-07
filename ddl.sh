#!/bin/bash
<<HI
project: DBMS <bash script>
describtion: this file represent DDl operation 
Authors: <Ismael Ramadan> .<Ahmed Abdelsalam>
HI

#Upon user Connect to Specific Database, there will be new Screen with this Menu:


tables_menu(){
    
    echo -e "\n~~~~~~~~~< choose from menu: >~~~~~~~~~~\n"
    echo "~~~~~~~< 1. Create Table       >~~~~~~~"
    echo "~~~~~~~< 2. List Tables        >~~~~~~~"
    echo "~~~~~~~< 3. Drop Table         >~~~~~~~"
    echo "~~~~~~~< 4. Insert into Table  >~~~~~~~"
    echo "~~~~~~~< 5. Select from Table  >~~~~~~~"
    echo "~~~~~~~< 6. Delete from Table  >~~~~~~~"
    echo "~~~~~~~< 7. Update Table       >~~~~~~~"
    echo "~~~~~~~< 8. Back               >~~~~~~~"
    echo "~~~~~~~< 9. Exit               >~~~~~~~"

    read -p "   Enter the Number of your choice:  " choice

    if (($choice >=1)) && (($choice <=9));then
        case $choice in 
            1) creating_table ;;
            2) listing_table ;;
            3) droping_table ;;
            4) insert_into_table ;;
            5) select_from_table ;;
            6) delete_from_table ;;
            7) updating_table ;;
            8) . /home/ismailramadan/DevOps/DBMS/main.sh ;;
            9) exit ;;
            *) echo "Ooops! wrong input <<check again>>" tables_menu
        esac
    else
        echo "Wrong input !!" 
        tables_menu
    fi

}


####### creating table  section #############


creating_table()
{
    
    read -p "Enter table name: " tname
	if [[ "$tname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -f "$tname" ];then
			echo " Table already exist !"
			creating_table
		else
            touch $tname
            touch $tname.metadata
            read -p "Enter number of columns:  " n_col
            if (($n_col >=1)) && (($n_col <=20));then
            echo "Remember: First Column is 'Primary Key' "
            columns
            echo "'$tname' created successfully ! "
            cat $tname.metadata
            tables_menu
            else
                echo " invalid input !! "
                rm $tname
                rm $tname.metadata
                creating_table
            fi


		fi			
	else
		echo -e "Enter Valid name plz!! \n"
		creating_table
	fi
    ######################
}
columns(){
    for ((i=1;i<=$n_col;i++))
    {
              
        read -p "Enter column'$i' name: " col
            if [[ "$col" =~ ^[a-zA-Z]{2,15}$ ]];then
                echo -e "choose data type \n    [1] Integer  [2] String >> "
                read col_type
                if (($col_type==1)) || (($col_type ==2));then
                    case $col_type in 
                        1) col_type="int" ;;
                        2) col_type="string" ;;
                        *) echo "invalid choice!!" 
                    esac
                    echo "$col:$col_type">>$tname.metadata
                else
                    echo "Invalid input!!"
                    sed -i d $tname.metadata
                    columns
                fi
            else
                echo "Invalid Column Name !"
                sed -i d $tname.metadata
                columns
            fi
    }
}



####### listing tables section ##############



listing_table()
{
    if [[ $(ls -A $PWD) ]];then
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        ls -F $PWD | grep -v ".metadata"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    else
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "\nOoops. No Tables to Display " 
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

    fi
    tables_menu
}


####### dropping table section ##############


droping_table()
{
    #echo "Hello from << droping_table >> function !"
    read -p "Enter table name: " tname
	if [[ "$tname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -f "$tname" ];then
            rm $tname
            rm $tname.metadata
            echo "'$tname' Dropped successfully ! "
            tables_menu
			
		else
            echo " $tname doesn't exist !"
			droping_table
		fi			
	else
		echo -e "Enter Valid name plz!! \n"
		droping_table
	fi
    tables_menu
}



####### inserting into table section ##########


insert_into_table()
{
    read -p "Enter table name: " tname
	if [[ "$tname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -f "$tname" ];then
            IFS=$'\n' read -d '' -r -a lines <"$tname.metadata"
            newrecord=""
            for i in "${!lines[@]}"
            do
                IFS=':' read -r -a field <<< "${lines[i]}";
                fieldname=${field[0]};
                fieldtype=${field[1]};
                count=0
                pk=0

                echo "Enter value of  '$fieldname' :    "
                read fieldvalue
                    


                #primary key
                if [[ $i -eq 0 ]]
                then
                    IFS=$'\n' read -d '' -r -a data < "$tname"
                    #echo "${data[@]}"

                    for j in "${!data[@]}"
                    do
                        IFS=':' read -r -a record <<< "${data[j]}"
                        if [[ $record[0] == $fieldvalue ]]
                        then
                            pk=1
                            echo "primary key must be uniqe"
                        fi
                    
                    done
                fi

                if [[ $fieldtype == "int" ]]
                then
                    if ! [[ $fieldvalue =~ ^[0-9]+$ ]]
                    then
                        count=1
                        echo " value must be number"
                    fi
                fi


                if [[ $count -eq 0 ]]
                then
                    if [[ $i -eq 0 ]]
                    then
                        newrecord=$fieldvalue
                    else
                        newrecord="$newrecord:$fieldvalue"
                    fi
                else
                    echo "invalid record"
                fi

            done
            if ! [[ $newrecord == "" ]]
            then
                echo $newrecord>>"$tname"
                echo "Record Stored successfully"
            else
                echo "Record Empty!!"
                insert_into_table
            fi
		else
            echo " $tname doesn't exist !"
			insert_into_table
		fi			
	else
		echo -e "Enter Valid name plz!! \n"
		insert_into_table
	fi
    tables_menu
    
        tables_menu
}


###### select from table #####################
selAll()
{
    echo "ـــــــــــــــــــــــــــــــــــــــــ"
    awk -F: 'BEGIN { ORS=":" }; { print $1 }' $tname.metadata
    #hint: ORS stands for output record separator
    printf "\n"
    echo "ـــــــــــــــــــــــــــــــــــــــــ"
    cat  $tname 
    echo -e "\nـــــــــــــــــــــــــــــــــــــــــ"

}
selcol()
{
    read -p "Enter coulmn name: " colname
        if  grep -q $colname $tname.metadata ; then
            read -p "Enter $colname value:  " colval
            result=$(grep $colval $tname)
            echo $result
        else
            echo "Doesn't Exist ! try Again.."
        fi
}


select_from_table()
{
    echo "Enter Table Name :"
    read tname
    if [ -f "$tname" ] && [ -f  "$tname.metadata" ]; then
        echo -e "choose Selection type \n    [1] Select All >>   [2] Select by Column >>   "
        read sel_type 
        if (($sel_type==1)) || (($sel_type ==2));then
            case $sel_type in 
                1) selAll ;;
                2) selcol ;;
                *) echo "invalid choice!!" 
            esac
        else
            select_from_table
        fi
    else 
        echo "$tname Doesn't Exist!!"
        select_from_table
    fi
    tables_menu
}


##### delete from table #######################


delete_from_table()
{
    read -p "Enter table name: " tname
	if [[ "$tname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -f "$tname" ];then
            read -p "Enter column name:  " colname
            column_names=($(awk -F: '{print $1}' $tname.metadata))
            checkcol=0
            for i in "${!column_names[@]}"
            do
                if [[ $colname == "${column_names[i]}" ]];then
                    checkcol=1
                    colNum=$(($i+1))
                fi
            done
            if [[ $checkcol == 1 ]];then
                read -p "Enter the value to delete record:  " rval
                rnumber=($(awk -v varCol="$colNum" -v varValue="$rval" -F: '{if ($varCol == varValue) {print FNR}}' "$tname"))
                c=0
                for i in "${!rnumber[@]}"
                do
                    index=${rnumber[$i]}
                    index=$(($index-$c))
                    sed -i "$index"d $tname
                    c=$(($c+1))
                done
                echo " deleted !!"
                tables_menu
            else
                echo "Invalid column name!!"
                delete_from_table
            fi
		else
            echo " $tname doesn't exist !"
			delete_from_table
		fi			
	else
		echo -e "Enter Valid name plz!! \n"
		delete_from_table
	fi
    tables_menu

    tables_menu
}


##### updating table ###########################


updating_table()
{
    read -p "Enter table name: " tname
	if [[ "$tname" =~ ^[a-zA-Z]{3,15}$ ]];then
		if [ -f "$tname" ];then
            read -p "Enter column name:  " colname
            column_names=($(awk -F: '{print $1}' $tname.metadata))
            checkcol=0
            count=-1
            for i in "${column_names[@]}"
            do
                count=$count+1
                if [[ $colname == $i ]];then
                    checkcol=1
                    colNum=$(($count+1))
                    echo $i
                fi
            done
            if [[ $checkcol == 1 ]];then
                read -p "Enter the record value you need to update:  " rval
                read -p "Enter the new value :  " nval
                u_recordes=($(awk -v varcol="$colNum"  -F: '{print $varcol}'  $tname ))
                c=0
                index=0
                for j in "${u_recordes[@]}"
                do
                    index=$(($index+1))
                    if [[ $rval == $j ]];then
                        index1=$index
			            index1=$(($index1-$c))
                        sed -i "$index""s/$rval/$nval/g" $tname
                        c=$(($c+1))
                    fi
                done
                echo "$rval updated to $nval !!"
                tables_menu
            else
                echo "Invalid column name!!"
                updating_table
            fi
		else
            echo " $tname doesn't exist !"
			updating_table
		fi			
	else
		echo -e "Enter Valid name plz!! \n"
		updating_table
	fi
    tables_menu
}

############
tables_menu
###########