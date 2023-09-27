PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

 
PUXAR() {
    EL_ATOMIC="$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$A' OR name='$A' OR atomic_number=$A")"
    ELEMENTO_NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number=$A")"
    ELEMENTO_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$A")"
    ELEMENTO_TYPE="$($PSQL "SELECT type FROM types JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $A")"
    #mass
    ELEMENTO_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$A")"
    #melting_point
    ELEMENTO_MELTING="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$A")"
    #boiling_point
    ELEMENTO_BOILING="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$A")"

    echo "The element with atomic number $EL_ATOMIC is $ELEMENTO_NAME ($ELEMENTO_SYMBOL). It's a $ELEMENTO_TYPE, with a mass of $ELEMENTO_MASS amu. $ELEMENTO_NAME has a melting point of $ELEMENTO_MELTING celsius and a boiling point of $ELEMENTO_BOILING celsius." 
}
#if run ./element.sh "Please  provide an element as an argument" and finishing running.
if [[ -z $1 ]] ;
  then
    echo "Please provide an element as an argument."

  elif ! [[ $1 =~ ^[0-9]+$ ]] ; then
        up=$1
        str=${up^}
        B="$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$str' OR name='$str' ")"
        if ! [[ -z $B ]] ;
          then 
            A=$B
            PUXAR
          else
            echo "I could not find that element in the database."  
            
        fi
  elif [[ $1 =~ ^[0-9]+$ ]] ; then
        Q="$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")"
        if ! [[ -z $Q ]] ;
          then 
            A=$Q
            PUXAR
          else
            echo "I could not find that element in the database."  
            
        fi
fi
 
