#! /bin/bash


if [[ $1 == "test" ]]
then
  PSQL="psql  --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql  --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE table  teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
winner_id=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
if [[ $WINNER != "winner" ]]
  then
  if [[ -z $winner_id ]]
  then
  insert_team=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $insert_team == "INSERT 0 1" ]]
    then
    echo  inserted into teams, $WINNER
    fi
  fi
fi

opponent_id=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
if [[ $OPPONENT != "opponent" ]]
  then
  if [[ -z $opponent_id ]]
  then
  insert_team2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $insert_team2 == "INSERT 0 1" ]]
    then
    echo  inserted into teams, $OPPONENT
    fi
  fi
fi

winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")


if [[ -n $winner_id || -n $opponent_id ]]
then
  if [[ $YEAR != "year" ]]
  then
  insert_games=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $insert_games == "INSERT 0 1" ]]
   then
   echo Inserted into games, $YEAR 
    fi 
  fi
fi

done