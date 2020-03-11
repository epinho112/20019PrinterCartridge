 #!/usr/local/bin/bash

network="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')"

if [ $network = "ObservePoint" ] 
	then
		Printers=(10.8.0.30 10.8.0.31 10.8.0.32 10.8.0.33 10.8.0.34 10.8.0.35)
		
		declare -A COLORS
		COLORS[0]="Yellow Cartridge"
		COLORS[1]="Black Cartridge"
		COLORS[2]="Cyan Cartridge"
		COLORS[3]="Magenta Cartridge"

		for printer in "${Printers[@]}"
		do
		    curl http://$printer/ | grep [0-9]*%$ | perl -pe 's/^\s+//'| tr -d '%' >> /Users/erikpinho/Documents/Work/Scripts/1.txt
		done

		declare -A MYMAP

		index=1

		while read linha ; do
			MYMAP[$index]=$linha
		        index=$(($index+1))

		done < /Users/erikpinho/Documents/Work/Scripts/1.txt

		line=1

		while [ $line -lt 24 ]
		do
			if [ ${MYMAP[$line]} -gt 10 ]
		        then
		        echo "OK"
		   else
		   	color=$(($line%4))
		        echo ":X", ${MYMAP[$line]}, 10.8.0.3`expr $line / 4`, ${COLORS[$color]} >> /Users/erikpinho/Documents/Work/Scripts/printer_status.txt
		fi
		((line++))
		done

		/usr/local/bin/sendEmail -f opalertservices@gmail.com -t erik.pinho@observepoint.com -u Printers Status -s smtp.googlemail.com:587 -xu opalertservices -xp OpIsTheBestCompany -o tls=yes < /Users/erikpinho/Documents/Work/Scripts/printer_status.txt

		rm /Users/erikpinho/Documents/Work/Scripts/1.txt
		rm /Users/erikpinho/Documents/Work/Scripts/printer_status.txt
else
	echo "Not on ObservePoint Network"
fi

#TODO
# Script to get only the "--" symbols
# cat printerTest.txt | grep [[:blank:]][-][-]$ | perl -pe 's/^\s+//' > parse.txt 