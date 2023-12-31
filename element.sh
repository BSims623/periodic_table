#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

RETURN_ELEMENT() {
  echo "$1" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE 
  do 
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
}

NO_MATCH='TRUE'

if [[ -z $1 ]]
then
echo Please provide an element as an argument.
else
if [[ $1 =~ ^[0-9]+$ ]]
then
GET_DATA_USING_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
if [[ -z $GET_DATA_USING_ATOMIC_NUMBER ]]
then
echo I could not find that element in the database.
NO_MATCH='FALSE'
else
RETURN_ELEMENT "$GET_DATA_USING_ATOMIC_NUMBER"
NO_MATCH='FALSE'
fi
fi
if [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
then
GET_DATA_USING_SYMBOL=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
if [[ -z $GET_DATA_USING_SYMBOL ]]
then 
echo I could not find that element in the database.
NO_MATCH='FALSE'
else
RETURN_ELEMENT "$GET_DATA_USING_SYMBOL"
NO_MATCH='FALSE'
fi
fi
if [[ $1 =~ ^[A-Za-z]{3,}$ ]]
then
GET_DATA_NAME=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
if [[ -z $GET_DATA_NAME ]]
then 
echo I could not find that element in the database.
NO_MATCH='FALSE'
else
RETURN_ELEMENT "$GET_DATA_NAME"
NO_MATCH='FALSE'
fi
fi
if [[ $NO_MATCH = 'TRUE' ]]
then
echo I could not find that element in the database.
fi
fi

