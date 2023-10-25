PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

cat atomic_mass.txt | while read ATOMIC_NUMBER BAR ATOMIC_MASS
do 
echo $ATOMIC_NUMBER $ATOMIC_MASS 
done

GET_PROPERTIES_DATA=$($PSQL "SELECT * FROM properties")
# echo "$GET_PROPERTIES_DATA"
GET_ELEMENTS_DATA=$($PSQL "SELECT symbol FROM elements")
# echo "$GET_ELEMENTS_DATA"

TRANSFORM_SYMBOL_CASE() {
  echo $GET_ELEMENTS_DATA | tr ' ' '\n' | while read SYMBOL
do
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
UPPERCASE_FIRST_LETTER=$(echo $SYMBOL |  sed 's/^[a-z]/\U&/')
LOWERCASE_SECOND_LETTER=$(echo $UPPERCASE_FIRST_LETTER | sed 's/[A-Z]$/\L&/')
FINAL_CHECK=$(echo $LOWERCASE_SECOND_LETTER | sed 's/^[a-z]$/\U&/')
# echo $ATOMIC_NUMBER $FINAL_CHECK
UPDATE_PROPER_CASE_SYMBOL=$($PSQL "UPDATE elements SET symbol = '$FINAL_CHECK' WHERE atomic_number = $ATOMIC_NUMBER")
echo $UPDATE_PROPER_CASE_SYMBOL
done
}

SET_PROPERTIES_TYPE_ID() {
TYPES_DATA=$($PSQL "SELECT type_id FROM types")
echo $TYPES_DATA | tr ' ' '\n' | while read TYPE_ID
do
TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
INSERT_TYPE_ID=$($PSQL "UPDATE properties SET type_id = $TYPE_ID WHERE type = '$TYPE'")
echo $INSERT_TYPE_ID
done
}

# TRANSFORM_SYMBOL_CASE
# SET_PROPERTIES_TYPE_ID

: 'GET_DATA=$($PSQL "SELECT * FROM properties")
echo $GET_DATA| tr ' ' '\n' | while read THE_DATA
do
FILTER_BARZ=$(echo $THE_DATA | sed 's/|/ /g')
echo $FILTER_BARZ | while read ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
do
echo  $ATOMIC_NUMBER $TYPE
done
done '

GET_ELEMENT_DATA=$($PSQL "SELECT * FROM elements")
GET_PROPERTIES_DATA=$($PSQL "SELECT * FROM properties")
JOIN_DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number)")
echo $JOIN_DATA | tr ' ' '\n' | while read THE_DATA
do
FILTER_BARZ=$(echo $THE_DATA | sed 's/|/ /g')
echo $FILTER_BARZ
done
