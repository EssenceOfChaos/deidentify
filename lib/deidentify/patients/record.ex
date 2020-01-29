defmodule Deidentify.Patients.Record do
  @moduledoc """
  The Record model
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :admission_year, :string
    field :age, :string
    field :discharge_year, :string
    field :notes, :string
    field :zipcode, :string

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:age, :zipcode, :admission_year, :discharge_year, :notes])
    |> validate_required([:age])
  end
end
