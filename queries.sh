#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Delete all data from tables
echo $($PSQL "TRUNCATE games,teams RESTART IDENTITY")


# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals; do
  if [[ $winner != "winner" ]]; then
  echo $($PSQL "insert into teams(name) values('$winner') on conflict(name) do nothing")
  fi

  if [[ $opponent != "opponent" ]]; then
  echo $($PSQL "insert into teams(name) values('$opponent') on conflict(name) do nothing")
  fi

 winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'") 

if [[ $round != "round" ]]; then
echo $($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)")
fi
done
