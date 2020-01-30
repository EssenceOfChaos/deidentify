# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Deidentify.Repo.insert!(%Deidentify.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# alias Deidentify.Patients
alias Deidentify.Patients.Record

Deidentify.Repo.insert!(%Record{
  admission_year: "2008",
  age: "25",
  discharge_year: "2009",
  notes: "Patient lives.",
  zipcode: "10014"
})

Deidentify.Repo.insert!(%Record{
  admission_year: "2014",
  age: "26",
  discharge_year: "2014",
  notes: "Patient likes oranges.",
  zipcode: "10013"
})

Deidentify.Repo.insert!(%Record{
  admission_year: "2002",
  age: "29",
  discharge_year: "2002",
  notes: "Patient likes dancing.",
  zipcode: "10016"
})

Deidentify.Repo.insert!(%Record{
  admission_year: "2000",
  age: "34",
  discharge_year: "2009",
  notes: "Patient likes walking.",
  zipcode: "10019"
})
