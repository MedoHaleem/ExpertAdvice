# ExpertAdvice

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Run Test

You run the test suits by simply typing ``` mix test ```

# Design Decisions 
I built the app according to specs as much as possible, here I'm going to list some points I wish had done if I had more time or wasn't according to specs provided:

According to specs, everything would be under `Accounts` Context which I did do that, personally I would have separated the context to two one called `Accounts` which contains the user and the other called `Contents`, which was going to contains `questions`, `answers` which were going to be seperate table instead of one table for post to handle.

My second decision was Authentication do I use 3rd party library like Guardian that have JWT solution or I simply roll my own authentication using phoenix sessions, I went with the latter as the app is simple enough and web only.

Third, I always write tests as I build my application, piece by piece, but I wrote tests this time at the end after finishing all the features for saving time and the app being small.


