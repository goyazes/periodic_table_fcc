#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#   ~~ primeiro inserir na tabela teams ~~
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNERGOALS != 'winner_goals' && $OPPONENTGOALS != 'opponent_goals' ]]
then
#get winner_id, opponent_id and games_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

#if not found WINNER_ID
  if [[ -z $WINNER_ID ]]
    then
      #insert WINNER_ID
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo "Adicionado winner: $WINNER"
      #get new WINNER ids
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  fi

  #if not found OPPONENT_ID
  if [[ -z $OPPONENT_ID ]]
  then
    #insert OPPONENT_ID
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ")
    echo "Adicionado opponent: $OPPONENT"
    #get new opponent ids
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi

GAMES_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WINNERGOALS AND opponent_goals=$OPPONENTGOALS AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")
  # ~~ INSERT IN games TABLE
  #if not found
  if [[ -z $GAMES_ID ]]
  then
    #insert
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNERGOALS, $OPPONENTGOALS)")
    
    echo "$YEAR, '$ROUND', $WINNER, $OPPONENT, $WINNERGOALS, $OPPONENTGOALS" 
    #get new ids
    GAMES_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WINNERGOALS AND opponent_goals=$OPPONENTGOALS AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")
  fi
  
fi
done