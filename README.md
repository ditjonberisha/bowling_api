# Bowling API

## Introduction

This API provides some basic services for a standard bowling game. In this API you can create new game, a way to input number of pins knocked down by each ball and outputs of the score (total score and score per each frame).

For more info about the rules, refer to [doc](doc/bowling.md).

---

# Install

## Dependencies
- Install [Ruby] >= 2.3.1
- Install [Rails] ~> 5.2.4
- Install [PostgreSQL]

## Run

1. Clone repo:
    ```
    git clone https://github.com/ditjonberisha/bowling_api.git
    ```
2. Run bundle install inside the dir
    ```
    bundle install
    ```
3. Copy env_sample and change values
    ```
    cp .env_sample .env
    ```
4. Create the database and run migration
     ```
    rails db:setup
    rails db:migrate
    ```
5. Run the server:
    ```
    rails s
    ```

## Rspec Test

Run rspec tests:
```
rspec
```

---
# API Documentation

## Create New Game

Creates new game (name attribute require)
```
POST localhost:3000/api/v1/games?name=:string
```
Response:
```
{
  "id": 123
  "name": "user",
  "status": "active"
}
```

## Get Results

Get results of the game
```
GET localhost:3000/api/v1/games/:id
```
Response:
```
{
  id: 123,
  name: "user",
  total_score: 300,
  status: "completed",
  frames: [
            {
                number: 1,
                first_ball: 10,
                second_ball: 10,
                third_ball: 10,
                status: "strike",
                score: 30
            },
            ...
            {
                number: 10,
                first_ball: 10,
                second_ball: 10,
                third_ball: 10,
                status: "strike",
                score: 30
            }
  ]
}
```

## Add Points

Adding points in the game. Required ID of the game and Points (value must be an integer between 0 and 10).
```
GET localhost:3000/api/v1/games/:id/points?points:integer(0..10)
```
Response:
```
{
  "status": 200,
  "result": {
      "id": 123,
      "points": 10,
      "shot": "first_ball",
      "type": "strike"
  }
}
```
In case of any error you will receive this format:
```
{
    "status": status,
    "error": "type of the error",
    "message": "message of the error"
}
```