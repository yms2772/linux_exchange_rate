#!/bin/bash

clear

CACHE=$HOME/cache_exchange_rate
DATE=$(date +%s)

if [ ! -e $CACHE ]
then
mkdir -p $CACHE
fi

echo -n "! 환율정보 불러오는 중..."

curl -s "https://ko.exchange-rates.org/" | grep '"cross-rate"' | head -7 | cut -f2 -d'>' | sed 's/<br//g' > $CACHE/exchange-rate.info

echo " [완료]"
echo
read -p "! 금액 (단위: WON): " won

echo "
@ KRW (원): \\$won

@ USD (달러): \$$(printf %.2f $(echo "$(head -1 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ EUR (유로): €$(printf %.2f $(echo "$(head -2 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ JPY (엔): ¥$(printf %.2f $(echo "$(head -3 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ GBP (파운드): £$(printf %.2f $(echo "$(head -4 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ AUD (AU달러): AU\$$(printf %.2f $(echo "$(head -5 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ HKD (HK달러): HK\$$(printf %.2f $(echo "$(head -6 $CACHE/exchange-rate.info | tail -1) * $won" | bc))

@ CAD (C달러): C\$$(printf %.2f $(echo "$(head -7 $CACHE/exchange-rate.info | tail -1) * $won" | bc))
"
