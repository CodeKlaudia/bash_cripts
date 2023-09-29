#!/usr/bin/env bash
# Author: Code Klaudia

unset configuredClient

currencyCodes=(AUD BAM BGN BMD BND BRL CAD CHF CNY CZK DJF DKK
  EUR GBP HKD HRK HUF IDR ISK ILS INR
  JPY KRW MXN MYR NOK NZD PAB PHP PLN
  RON RUB SEK SGD THB TRY USD ZAR)
  
  
checkValidCurrency()
{
  if [[ "${currencyCodes[*]}" == *"$(echo "${@}" | tr -d '[:space:]')"* ]]; then
    echo "0"
  else
    echo "1"
  fi
}

  peggedTo()
  {
    case "$@" in
      BAM)  echo "EUR:1.95583" ;;
      BMD)  echo "USD:1.0" ;;
      BND)  echo "SGD:1.0" ;;
      DJF)  echo "USD:177.721" ;;
      PAB)  echo "USD:1.0" ;;
      *)    echo "1" ;;
    esac
  }

  ## This function determines which http get tool the system has installed and returns an error if there isnt one
  getConfiguredClient()
  {
    if command -v curl &>/dev/null; then
      configuredClient="curl"
    elif command -v wget &>/dev/null; then
      configuredClient="wget"
    elif command -v http &>/dev/null; then
      configuredClient="httpie"
    elif command -v fetch &>/dev/null; then
      configuredClient="fetch"
    else
      echo "Error: This tool requires either curl, wget, httpie or fetch to be installed." >&2
      return 1
    fi
  }



  ## Allows to call the users configured client without if statements everywhere
  httpGet()
  {
    case "$configuredClient" in
      curl)  curl -A curl -s "$@" ;;
      wget)  wget -qO- "$@" ;;
      httpie) http -b GET "$@" ;;
      fetch) fetch -q "$@" ;;
    esac
  }
