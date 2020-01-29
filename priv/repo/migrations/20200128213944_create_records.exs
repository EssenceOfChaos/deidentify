defmodule Deidentify.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :age, :string
      add :zipcode, :string
      add :admission_year, :string
      add :discharge_year, :string
      add :notes, :text

      timestamps()
    end
  end
end
