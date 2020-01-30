defmodule Deidentify.Patients do
  @moduledoc """
  The Patients context.
  """

  import Ecto.Query, warn: false
  alias Deidentify.Repo

  require Logger

  alias Deidentify.Patients.Record
  alias Deidentify.ZipcodeManager

  @doc """
  Returns the list of records.

  ## Examples

      iex> list_records()
      [%Record{}, ...]

  """
  def list_records do
    Repo.all(Record)
  end

  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id), do: Repo.get!(Record, id)

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    deidentify(attrs)
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{source: %Record{}}

  """
  def change_record(%Record{} = record) do
    Record.changeset(record, %{})
  end

  def deidentify(%{"record" => record} = _record_params) do
    deidentify(record)
  end

  def deidentify(
        %{
          "admissionDate" => admissionDate,
          "birthDate" => birthDate,
          "dischargeDate" => dischargeDate,
          "notes" => notes,
          "zipCode" => zipCode
        } = _record_params
      ) do
    %Record{
      admission_year: calculate_year(admissionDate),
      age: calculate_age(birthDate),
      discharge_year: calculate_year(dischargeDate),
      notes: normalize_notes(notes),
      zipcode: calculate_zip(zipCode)
    }
  end

  ## Private Functions ##
  defp calculate_age(string_date) when is_nil(string_date), do: string_date

  defp calculate_age(string_date) when is_binary(string_date) do
    dob = Date.from_iso8601!(string_date)
    today = Date.utc_today()
    Integer.to_string(today.year - dob.year)
  end

  defp calculate_year(string_date) when is_nil(string_date), do: string_date

  defp calculate_year(string_date) when is_binary(string_date) do
    d = Date.from_iso8601!(string_date)
    Integer.to_string(d.year)
  end

  defp calculate_zip(zip_string) do
    ZipcodeManager.normalize_zip(zip_string)
  end

  defp normalize_notes(notes) when is_nil(notes), do: notes

  defp normalize_notes(notes) when is_binary(notes) do
    Logger.info("normalize notes being called")

    if String.contains?(notes, "/") do
      words = String.split(notes)
      date = Enum.filter(words, fn word -> String.contains?(word, "/") end)
      date_string = hd(date)
      l = String.split(date_string, "/")
      year = List.last(l)
      String.replace(notes, date_string, year)
    else
      String.replace(notes, ~r/\d/, "X")
    end
  end
end
