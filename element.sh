#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

INPUT=$1

if [[ -z $INPUT ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Determinar el tipo de entrada
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  QUERY_CONDITION="atomic_number=$INPUT"
elif [[ ${#INPUT} -le 2 ]]; then
  QUERY_CONDITION="symbol='$INPUT'"
else
  QUERY_CONDITION="name='$INPUT'"
fi

# Ejecutar la consulta
DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $QUERY_CONDITION")

if [[ -z $DATA ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Leer y mostrar el resultado
IFS="|" read NUMBER SYMBOL NAME MASS MELTING BOILING TYPE <<< "$DATA"

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
