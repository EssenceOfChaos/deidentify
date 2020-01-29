defmodule DeidentifyWeb.RecordView do
  use DeidentifyWeb, :view
  alias DeidentifyWeb.RecordView

  def render("index.json", %{records: records}) do
    %{data: render_many(records, RecordView, "record.json")}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{
      id: record.id,
      age: record.age,
      zipcode: record.zipcode,
      admission_year: record.admission_year,
      discharge_year: record.discharge_year,
      notes: record.notes
    }
  end
end
