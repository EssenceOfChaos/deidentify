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

I've also included the Postman collection. This can be run from the Postman gui or from the command line. To run the tests from the command line you'll need the npm package `newman` installed, you can then run `newman run deidentify.postman.json` from the command line. **Note: for the newman/postman tests to run correctly the application needs to be running i.e. `mix phx.server` from the command line.**

The test output is as follows:

```bash
Deidentify

→ Post - ssn
POST http://localhost:4000/api/records [201 Created, 392B, 6.6s]
✓ Status code is 201
✓ Verify admission_year is just the year from admissionDate
✓ Verify discharge_year is just the year from dischargeDate
✓ Verify the social security number is blocked out

→ Post - date
POST http://localhost:4000/api/records [201 Created, 385B, 730ms]
✓ Status code is 201
✓ Verify any dates just show the year
✓ A person over 90 should just show 90

┌─────────────────────────┬──────────────────┬──────────────────┐
│ │ executed │ failed │
├─────────────────────────┼──────────────────┼──────────────────┤
│ iterations │ 1 │ 0 │
├─────────────────────────┼──────────────────┼──────────────────┤
│ requests │ 2 │ 0 │
├─────────────────────────┼──────────────────┼──────────────────┤
│ test-scripts │ 2 │ 0 │
├─────────────────────────┼──────────────────┼──────────────────┤
│ prerequest-scripts │ 0 │ 0 │
├─────────────────────────┼──────────────────┼──────────────────┤
│ assertions │ 7 │ 0 │
├─────────────────────────┴──────────────────┴──────────────────┤
│ total run duration: 7.9s │
├───────────────────────────────────────────────────────────────┤
│ total data received: 257B (approx) │
├───────────────────────────────────────────────────────────────┤
│ average response time: 3.7s [min: 730ms, max: 6.6s, s.d.: 3s] │
└───────────────────────────────────────────────────────────────┘
```
