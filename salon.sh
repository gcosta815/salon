#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT * FROM services;") 

  echo "$SERVICES" | while read ID BAR NAME; 
  do
    echo "$ID) $NAME"
  done

  echo -e "\nPick the service you want:\n"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    1) PAINTING ;;
    2) CLEANING ;;
    3) FIXING ;;
    *) MAIN_MENU "We don't offer that service, please pick one of the following:\n" ;;
  esac
}

CUSTOMER_INFO() {
  echo -e "\nWhat's your phone number?\n"

  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWe don't have that phone number, what's your name?\n"

    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  fi
}

SERVICE_INFO() {
  echo -e "\nWhat time do you want your $1 service?\n"

  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}

PAINTING() {
  CUSTOMER_INFO
  SERVICE_INFO 'Painting'
}

CLEANING() {
  CUSTOMER_INFO
  SERVICE_INFO 'Cleaning'
}

FIXING() {
  CUSTOMER_INFO
  SERVICE_INFO 'Fixing'
}

MAIN_MENU "Services available:\n"
