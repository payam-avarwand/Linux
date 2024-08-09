# Assuming there are 5 Fujitsu Storage systems, which have similar names: "HA-FJS-05" til "HA-FJS-09"
# We need separate lists of all Host Affinities on storage systems that contain just names of Host Affinities
# It's possible to call Host Affinities over SSH-Connections > CLI > "show host-affinity"
# The SSH addresses of our Fujitsu Storage systems are in the range 10.0.0.x | the last octets are not in any particular order!

#!/bin/bash


# define SSH-addresses
IP=10.0.0.
oct=(67 19 91 63 32)


# define variables
path=/home/Test-User/fujitsu-systems/script/
recipient="payam_avar@yahoo.com"
i=5
j=0


# call and save infos over SSH-Connections to Storage systems
while [ $i -lt 10 ]
do
        # establish a SSH-connection and run the command and save the second column of the output (only the name column) in a local csv File
        # the output will be excluded from not-HostAffinity lines over AWK command
        OPENSSL_CONF=~/openssl.cnf /usr/bin/ssh -tt root@$IP${oct[$j]} "show host-affinity" | awk '$2 !~ /^CA#|^CM#|^LUN|^show|^----------------|^Name/ {print $2}' > $path${i}.csv
        
        # to remove the empty Lines and save the result (final data) in a new file with a proper name
        sed '/^$/d' $path${i}.csv > $path"HA-FJS-0${i}.csv"
        
        # remove the first saved data file
        rm $path$i.csv
        
        let "i+=1"
        let "j+=1"
done


# send all final csv files to the desired email address
echo "In the attachment you find the lists of host affinities for individual Fujitsu storage devices." | /usr/bin/mutt -s "List of HostAffinities" -a $path*.csv -- $recipient

# remove all saved csv files
sleep 2
rm $path*.csv

