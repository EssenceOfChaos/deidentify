defmodule DeidentifyWeb.RecordController do
  use DeidentifyWeb, :controller

  alias Deidentify.Patients
  alias Deidentify.Patients.Record

  action_fallback DeidentifyWeb.FallbackController

  def index(conn, _params) do
    records = Patients.list_records()
    render(conn, "index.json", records: records)
  end

  def create(conn, record_params) do
    with {:ok, %Record{} = record} <- Patients.create_record(record_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def show(conn, %{"id" => id}) do
    record = Patients.get_record!(id)
    render(conn, "show.json", record: record)
  end

  def update(conn, %{"id" => id, "record" => record_params}) do
    record = Patients.get_record!(id)

    with {:ok, %Record{} = record} <- Patients.update_record(record, record_params) do
      render(conn, "show.json", record: record)
    end
  end

  def delete(conn, %{"id" => id}) do
    record = Patients.get_record!(id)

    with {:ok, %Record{}} <- Patients.delete_record(record) do
      send_resp(conn, :no_content, "")
    end
  end
end
