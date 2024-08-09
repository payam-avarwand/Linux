# We have 50 Broadcom SAN-Switches, and sometimes we need to connect to them over ssh-CLI to run a command.
# To run this script, it will need 2 Arguments:
    # the first one will be the last octet of the Switch SSH-address, since the first octet of all Switch addresses are the same> 10.1.5.X
    # the second one will be the command we are going to run on the Switch
# The Output of the desired command will be sent as an Email

#!/bin/bash

# define Variables
LO=$1
COM=$2
oCom=`echo $COM | tr a-z A-Z`
IP=10.1.5.$LO
PW=`cat /home/Test-User/pass.txt`
path=/home/Test-User/switchs
recipient="payam_avar@yahoo.com"

# To find the Host name of the Switch
SWN=`echo y | /usr/bin/plink -no-antispoof -ssh  -C root@$IP -pw $PW switchname`
NAME=$SWN
DATA="$LO--$COM--$NAME".txt

# establish a SSH-connection and run the command and save the output in a local txt File
echo y | /usr/bin/plink -no-antispoof -ssh -C root@$IP -pw $PW $COM > $path/$DATA

# Send the Output saved file as an attachement over an Email
echo "Here is the Output of running the  $oCom on $NAME ." | /usr/bin/mutt -s "$oCom on $NAME" -a $path/$DATA -- $recipient

# remove the saved txt file
sleep 2
rm $path/$DATA
