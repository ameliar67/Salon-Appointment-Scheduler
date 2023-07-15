#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e '\n ~~ Salon ~~ \n'

MAIN_MENU()   {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo "Which salon service are you looking for today?"
  echo -e '\n1) Hair Color \n2) Wax \n3) Haircut \n4) Exit'
  read SERVICE_ID_SELECTED


  if [[ ! $SERVICE_ID_SELECTED =~ [0-4] ]]
  then
  MAIN_MENU "Please select a valid option"
  fi

  if [[ $SERVICE_ID_SELECTED == 4 ]]
  then
  EXIT
  exit
  fi
  
  echo -e '\nPlease enter your phone number'
  read CUSTOMER_PHONE
  echo $CUSTOMER_PHONE

  # check phone number input format is valid
  if [[ ! $CUSTOMER_PHONE =~ ^[0-9-]+$ ]]

  then
  echo -e "\nThis is not a valid phone number"
  COLOR_MENU
  fi

  # check if phone number exists in the system
  EXISTING_CUSTOMER_PHONE_TEST="$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")"
  echo $EXISTING_CUSTOMER_PHONE_TEST

  # if phone number does not exist in system
  if [[ -z $EXISTING_CUSTOMER_PHONE_TEST ]]
  then 

  # get customer name
  echo -e '\nPlease enter your name'
  read CUSTOMER_NAME
  echo $CUSTOMER_NAME

  # insert name and phone number into customers table
  $PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"


  #get time
  echo -e '\nPlease enter a time for the selected service'
  read SERVICE_TIME
  echo $SERVICE_TIME

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo $CUSTOMER_ID

  # insert data into appointments table
   $PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME')"

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  exit

  # if phone number is in system
  else


  #get time
  echo -e '\nPlease enter a time for the selected service'
  read SERVICE_TIME
  echo $SERVICE_TIME

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo $CUSTOMER_ID
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")

  # insert data into appointments table
  $PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME')"

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."

  fi
  exit

}

EXIT ()   {
echo -e "\n Thank you for stopping in."
}

MAIN_MENU

exit

