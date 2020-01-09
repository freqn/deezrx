# DeezRx

## Important Instructions

To start Deezrx:

  1) Install dependencies with `mix deps.get`
  2) Fetch Node.js dependencies with `cd assets && npm install`
  3) Generate the database and seed data with `mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs`
  4) Start Phoenix endpoint with `mix phx.server`, or with `iex -S mix phx.server` for debugging
  5) Visit [`localhost:4000`](http://localhost:4000) from your browser

Please [check the deployment guides](http://www.phoenixframework.org/docs/deployment) for production notes.

## Test Users:

  - Default demo password for all users: password123

**Pharmacy Access:**

  - betterrx@test.com

  - bestrx@test.com

  - drugsrus@test.com

**Courier Access:**

  - sameday@test.com

  - previousday@test.com

**Admin Access:** 

  - admin@test.com

<hr>

## Answers to Project Questions:

**What was the hardest part of the implementation?**

The hardest part was engineering the relationship between pharmacies and couriers. Should it be a many-many, etc? Since it seemed vague and open-ended, I first opted to allow the orders to dictate that connection (I envisioned a pharmacy having a list of couriers to choose from when creating an order), but then I decided to create an internal mapping (join table) between the two models (since couriers service pharmacies in the requirements) in order to associate the two. My struggle with this was how to use Ecto along with the relationship declarations I added to the schemas to derive that connection instead of what I implemented in the create method of the order controller. The configuration with Ecto, along with preloading, especially parent associations (how do I get courier names from the orders to display in the index view when loggged in as a pharmacy?) are topics I'm still confused about.

Working with dates and time was also challenging when sorting out my queries :).


**What would be your next couple of tasks if you had more time?**

I'll answer this with a list:

1) Test coverage - I was unclear on how to test the role-based access I implemented in the order controller.
    
2) If I had time, I'd revisit my implementation or role-based action handling and possibly refactor.

3) Refactoring the pharmacy, courier, and admin actions into separate controllers
   
4) Implementing all of the optional items in the assignment. I started moving toward the admin features early-on since I started the project by modeling the basic CRUD actions for the entities within the Accounts context, and the admin piece seemed more natural once I figured out how I wanted to implement the roles. I'd definitely continue in that direction. The reporting aspect also seems like a very interesting feature to work on.


**How could we change the project to be more interesting?**

1) Add bonus points for live notifications or any live-view things (chat, etc.) :)
   
2) Add more time for those of use who are newer to Elixir and Phoenix. I wanted to be much more thorough with certain aspects of this project :)


Don't hesitate to contact me with additional questions.

Thank you





