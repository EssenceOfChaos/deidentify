defmodule Deidentify.PatientsTest do
  use Deidentify.DataCase

  alias Deidentify.Patients

  describe "records" do
    alias Deidentify.Patients.Record

    @valid_attrs %{admission_year: "some admission_year", age: "some age", dischargeYear: "some dischargeYear", notes: "some notes", zipcode: "some zipcode"}
    @update_attrs %{admission_year: "some updated admission_year", age: "some updated age", dischargeYear: "some updated dischargeYear", notes: "some updated notes", zipcode: "some updated zipcode"}
    @invalid_attrs %{admission_year: nil, age: nil, dischargeYear: nil, notes: nil, zipcode: nil}

    def record_fixture(attrs \\ %{}) do
      {:ok, record} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Patients.create_record()

      record
    end

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Patients.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Patients.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      assert {:ok, %Record{} = record} = Patients.create_record(@valid_attrs)
      assert record.admission_year == "some admission_year"
      assert record.age == "some age"
      assert record.dischargeYear == "some dischargeYear"
      assert record.notes == "some notes"
      assert record.zipcode == "some zipcode"
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      assert {:ok, %Record{} = record} = Patients.update_record(record, @update_attrs)
      assert record.admission_year == "some updated admission_year"
      assert record.age == "some updated age"
      assert record.dischargeYear == "some updated dischargeYear"
      assert record.notes == "some updated notes"
      assert record.zipcode == "some updated zipcode"
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Patients.update_record(record, @invalid_attrs)
      assert record == Patients.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Patients.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Patients.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Patients.change_record(record)
    end
  end
end
