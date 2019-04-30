#!/bin/bash

server=10.1.0.237

requestHeader='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:proc="http://processing.cards.crystals.ru/"><soapenv:Header/><soapenv:Body>'
requestFooter='</soapenv:Body></soapenv:Envelope>'
requestSubHeader='<proc:getActiveBonusAccounts>'
requestOffSubHeader='<proc:writeOffFromBonusAccount>'

requestBodyHeader='<cardNumber>'
requestBodyFooter='</cardNumber>'
requestSubFooter='</proc:getActiveBonusAccounts>'
requestOffSubFooter='</proc:writeOffFromBonusAccount>'

echo -e "Number;balance;2charge;will charge;nextCharge;BalanceAfter;BalanceMustBe" > result/all
#for number in $(cat list |awk '{print $1}'); 
grep -v '^ *#' < list|awk '{print $1}' | while IFS= read -r number
do
requestString=$requestHeader$requestSubHeader$requestBodyHeader$number$requestBodyFooter$requestSubFooter$requestFooter
response=$(echo "$requestString"|curl --header "Content-Type: text/xml;charset=UTF-8" --header 'SOAPAction:""' --data @- http://"$server":8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing 2>/dev/null)
echo $response > logs/re_$number.xml
echo -e "${response//></>\n<}" > logs/response_"$number".log
balance=$(echo "$response"|sed "s/<\/balance.*//g;s/.*balance>//g")
chargeoff=$(grep $number list|awk '{print $2/100}')
bonusAccountTypeCode=$(echo $response|sed "s/<\/bonusAccountTypeCode.*//g;s/.*bonusAccountTypeCode>//g")
if [ "$(awk -v n1="$balance" -v n2="$chargeoff" 'BEGIN {printf (n1<n2?"0":"1")}')"  = 1 ]
    then
	chargetOff=$chargeoff
	chargeONT=0
	nextbalance=$(echo "$balance" - "$chargeoff"|bc -l)
    else
	chargetOff=$balance
	chargeONT=$(echo "$chargeoff" - "$balance" |bc -l)
	nextbalance=0
fi
if [ "$chargetOff" == 0 ] ; then
echo -e "$number;$balance;$chargeoff;$chargetOff;$chargeONT;$balance;$balance" >> result/all
continue
fi
#echo continue with charge off on "$number" with "$chargetOff" on balance "$balance"
requestBody="<accountTypeCode>$bonusAccountTypeCode</accountTypeCode><cardNumber>$number</cardNumber><writeOffSum>$chargetOff</writeOffSum>"
requestOffString=$requestHeader$requestOffSubHeader$requestBody$requestOffSubFooter$requestFooter
echo "$requestOffString" > logs/request_$number.log
echo "$requestOffString"|curl --header "Content-Type: text/xml;charset=UTF-8" --header 'SOAPAction:""' --data @- http://"$server":8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing 2>/dev/null > logs/charget_$number.log
responseAfter=$(echo $requestString|curl --header "Content-Type: text/xml;charset=UTF-8" --header 'SOAPAction:""' --data @- http://"$server":8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing 2>/dev/null)
echo "$responseAfter" |sed "s/></>\n</g" > logs/after_"$number".log
balanceOff=$(echo "$responseAfter"|sed "s/<\/balance.*//g;s/.*balance>//g")

echo -e "$number;$balance;$chargeoff;$chargetOff;$chargeONT;$balanceOff;$nextbalance" >> result/all
done
