# Deidentify

To run this application you will need to have [Elixir](https://elixir-lang.org/install.html) and [Phoenix](https://hexdocs.pm/phoenix/installation.html) installed on your machine. Also, Postgres running on localhost on the default port.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/api/records`](http://localhost:4000/api/records) from your browser.

## Testing

Run the test suite with `mix test`.

If everything is installed correctly you should see, `11 tests, 0 failures`.
