defmodule DeidentifyWeb.RecordControllerTest do
  use DeidentifyWeb.ConnCase

  alias Deidentify.Patients
  alias Deidentify.Patients.Record

  @create_attrs %{
    "admissionDate" => "2019-03-12",
    "birthDate" => "2000-01-01",
    "dischargeDate" => "2019-03-14",
    "notes" => "Patient with ssn 123-45-6789 previously presented under different ssn",
    "zipCode" => "10013"
  }
  @update_attrs %{
    "admissionDate" => "2018-03-12",
    "birthDate" => "2005-01-01",
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

  def fixture(:record) do
    {:ok, record} = Patients.create_record(@create_attrs)
    record
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all records", %{conn: conn} do
      conn = get(conn, Routes.record_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create record" do
    test "renders record when data is valid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), record: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.record_path(conn, :show, id))

      assert %{
               "id" => id,
               "admission_year" => "2019",
               "age" => "20",
               "discharge_year" => "2019",
               "notes" => "Patient with ssn XXX-XX-XXXX previously presented under different ssn",
               "zipcode" => "100"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), record: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete record" do
    setup [:create_record]

    test "deletes chosen record", %{conn: conn, record: record} do
      conn = delete(conn, Routes.record_path(conn, :delete, record))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.record_path(conn, :show, record))
      end
    end
  end

  defp create_record(_) do
    record = fixture(:record)
    {:ok, record: record}
  end
end
