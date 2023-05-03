#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICE_MENU () {
  echo Welcome to My Salon, how can I help you
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SELECTED ;;
    2) SELECTED ;;
    3) SELECTED ;;
    4) SELECTED ;;
    5) SELECTED ;;
    *) SERVICE_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SELECTED () {
  # get the customer's phone number
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  # get customer's name in Database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # if customer is not registered
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get the customer's name
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert customer's info in database
    CUSTOMERS_INFO_INSERTED=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    
  fi

  # get the apointment time
  echo "What time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # get customer's id in database
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME' AND phone = '$CUSTOMER_PHONE'")
  # get service's name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  
  # insert information in appointment
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  
  # if insertion in database is succesful
  if [[ $INSERT_APPOINTMENT == 'INSERT 0 1' ]]
  then
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *//g') at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

SERVICE_MENU