defmodule Deidentify.PatientsTest do
  use Deidentify.DataCase

  alias Deidentify.Patients

  describe "records" do
    alias Deidentify.Patients.Record

    @valid_attrs %{
      "admissionDate" => "2019-03-12",
      "birthDate" => "2000-01-01",
      "dischargeDate" => "2019-03-14",
      "notes" => "Patient with ssn 123-45-6789 previously presented under different ssn",
      "zipCode" => "10013"
    }
    @update_attrs %{
      "admissionDate" => "2018-03-12",
      "birthDate" => "1995-01-01",
      "dischargeDate" => "2019-03-14",
      "notes" => "Patient with ssn 123-45-6788 has updated status",
      "zipCode" => "10018"
    }
    @invalid_attrs %{
      "admissionDate" => nil,
      "birthDate" => nil,
      "dischargeDate" => nil,
      "notes" => nil,
      "zipCode" => nil
    }

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
      assert record.admission_year == "2019"
      assert record.age == "20"
      assert record.discharge_year == "2019"

      assert record.notes ==
               "Patient with ssn 123-45-6789 previously presented under different ssn"

      assert record.zipcode == "100"
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_record(@invalid_attrs)
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
