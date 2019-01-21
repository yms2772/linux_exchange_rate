#!/bin/bash

clear

CACHE=$HOME/cache_exchange_rate
DATE=$(date +%s)

function CAL_EXCHANGE(){
ORG_RATE=$(head -n $1 $CACHE/exchange-rate.info | tail -1)
NEW_RATE=$(head -n $1 $CACHE/new_exchange-rate.info | tail -1)
PRT_EX=$(printf %.2f $(echo "$ORG_RATE * $won" | bc))
if [ "$EX_CHANGE" = 1 ]
then
EX_DIFF=$(echo "$NEW_RATE - $ORG_RATE" | bc)
echo "$PRT_EX   |   $(printf %.2f $(echo "scale=2; $EX_DIFF / $ORG_RATE" | bc))%"
else
echo $PRT_EX
fi
}

if [ ! -e $CACHE ]
then
mkdir -p $CACHE
fi

echo -n "! 환율정보 불러오는 중..."

curl -s "https://ko.exchange-rates.org/" | grep '"cross-rate"' | head -7 | cut -f2 -d'>' | sed 's/<br//g' > $CACHE/new_exchange-rate.info

if [ ! -e $CACHE/exchange-rate.info ]
then 
cp $CACHE/new_exchange-rate.info $CACHE/exchange-rate.info
fi

if [ "$(diff $CACHE/new_exchange-rate.info $CACHE/exchange-rate.info)" = "" ]
then
echo " [변동없음]"
else
echo " [변동]"
EX_CHANGE=1
fi

echo
read -p "! 금액 (단위: WON): " won

echo "
@ KRW (원): \\$won

@ USD (달러): \$$(CAL_EXCHANGE 1)

@ EUR (유로): €$(CAL_EXCHANGE 2)

@ JPY (엔): ¥$(CAL_EXCHANGE 3)

@ GBP (파운드): £$(CAL_EXCHANGE 4)

@ AUD (AU달러): AU\$$(CAL_EXCHANGE 5)

@ HKD (HK달러): HK\$$(CAL_EXCHANGE 6)

@ CAD (C달러): C\$$(CAL_EXCHANGE 7)
"

if [ "$EX_CHANGE" = 1 ]
then
mv $CACHE/new_exchange-rate.info $CACHE/exchange-rate.info
fi
