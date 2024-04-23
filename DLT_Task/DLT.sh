#!/usr/bin/bash

################################################################################
# Description: This script performs 1) Parsing Log file Information
#                                   2) Filteration of log entries acorting their entry
#                                   3) Summarization of log file
#
# Usage: ./DLT.sh [options]
#
#
# Example usage:
#   ./DLT.sh  ./log
#
# Author: Ahmed Mohamed Abdalla
# Date: April 23, 2024
# Version: 1.1
################################################################################

# Set the path to the log file

logfilename=$1
logfilename2=""

if [[ "$1" == *"./"* ]]; then
   logfilename2=${logfilename:2}
else
   logfilename2=logfilename
fi


path=$(pwd)/$logfilename2

# Initialize local_status to check file existence
typeset -i local_status=0


# Check if the file exists and only one argument is provided
if [ -f "$path" ] && [ "$#" -eq 1 ]; then
   echo $path
   local_status=1
else
   echo "Invalid path to file"
fi



# Function to parse log entries
function Log_Parsing()
{
   typeset -i l_counter=1
while IFS= read -r line; do
   date=${line:1:10}
   time=${line:12:8}

   echo -n "Record No."$l_counter-  date: "$date" time: "$time" >> "$(pwd)"/.out.txt

   awk -v i=$l_counter  '{ \
                           if (NR== i) { \
                                 
                                       printf " | log level: %s ",$3; \
                                       {printf"\n\t\t=>Message:"} \
                                       for ( field=4 ; field<=NF; field++) {printf " %s", $field;}\
                                       {printf"\n"}
                                       
                                       } \
                           
                           
                        }' "$1" >> "$(pwd)"/.out.txt


   
   l_counter=$l_counter+1
done < "$1"

}


# Function to filter log entries
function Filter () {

   typeset -i my_option=0
   echo "1) INFO"
   echo "2) WARN"
   echo "3) ERROR"
   echo "4) DEBUG"
   
   printf "\nPlease, Enter parameter to filter: "
   read -r my_option

   

   l_option=""

   case "${my_option}" in
      1)
         l_option=INFO
         echo *********************INFO Logs********************* >> "${pwd}".outt.txt
      ;;
      2)
         l_option=WARN
         echo *********************WARN Logs********************* >> "${pwd}".outt.txt
      ;;
      3)
         l_option=ERROR
         echo *********************ERROR Logs********************* >> "${pwd}".outt.txt
      ;;
      4)
         l_option=DEBUG
         echo *********************DEBUG Logs********************* >> "${pwd}".outt.txt
      ;;
      *)
         echo "default (none of above)"
      ;;
   esac

      awk -v var=$l_option '{ \

                              if (var == $3) \
                              {\
                                 {var2=""}\
                                 for ( field=1 ; field<=NF; field++) {var2=$var2+$i;}\
                                 {print $var2 }\

                              } \


                           }' "$1" > "${pwd}".out.txt

}

# Function to summarize log entries
function Summarize () {
   echo -n "Number of \"INFO\"  logs is: "
   grep -o "INFO" "$1" | wc -l

   echo -n "Number of \"WARN\"  logs is: "
   grep -o "WARN" "$1" | wc -l

   echo -n "Number of \"ERROR\" logs is: "
   grep -o "ERROR" "$1" | wc -l

   echo -n "Number of \"DEBUG\" logs is: "
   grep -o "DEBUG" "$1" | wc -l
}

# Initialize output files
touch "${pwd}".out.txt 
touch "${pwd}".outt.txt 

#cleaning output files
cat /dev/null > "${pwd}".out.txt
cat /dev/null > "${pwd}".outt.txt



# Check if the file exists and proceed with menu options
if (( 1 == local_status )); then
   
while [ true ]; do
   clear
   echo "********************** Welcome to the DLT Log Analyzer **********************"
   echo "1) Log_Parser"
   echo "2) Filter"
   echo "3) Summarize"
   echo "4) DEBUG"
   echo "5) Report Generation"
   echo "6) Exit"
   echo "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
   echo ""
   
   if (("v_option == 2")); then
      cat ${pwd}.outt.txt
      cat ${pwd}.out.txt
      cat /dev/null > "${pwd}".outt.txt
      
   else
      cat ${pwd}.out.txt
   fi
   

   echo ""
   echo -n "Please, Enter your option: "
   read  v_option
   

   case "${v_option}" in
      1)
         
         Log_Parsing "$1" >.out.txt

      ;;
      2)
         Filter "$1" 
      ;;
      3)
         Summarize "$1">.out.txt
      ;;
      4)
         #Summarize "$1"
      ;;
      5)
         #Summarize "$1"
      ;;
      6)
         echo "" > "${pwd}".out.txt
         exit

      ;;
      *)
         echo "default (none of above)"
      ;;
   esac
   
done

else
echo -n "" #Nothing
fi

#[2024-04-06 08:15:32] INFO System Startup Sequence Initiated
#[2024-04-06 08:15:34] WARN Deprecated API usage detected: api_v1_backup
#[2024-04-06 08:16:01] ERROR Unable to initialize network interface: eth0
#[2024-04-06 08:16:05] INFO Network interface initialized successfully: eth1
#[2024-04-06 08:17:42] DEBUG Process A started with PID: 1234
#[2024-04-06 08:18:03] WARN Memory usage exceeds threshold: 85%
#[2024-04-06 08:19:10] ERROR Disk write failure on device: /dev/sda1
#[2024-04-06 08:20:00] INFO System health check OK
