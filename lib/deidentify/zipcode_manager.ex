defmodule Deidentify.ZipcodeManager do
  @moduledoc """
  The ZipcodeManager determines if a zipcode should be zeroed out or sliced.
  """
  use GenServer

  require Logger

  ## ------------------------------------------------- ##
  ##                   Client API                      ##
  ## ------------------------------------------------- ##
  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def reset_state(name) do
    GenServer.cast(name, :reset_state)
  end

  def stop(name) do
    GenServer.cast(name, :stop)
  end

  def normalize_zip(zipcode) do
    GenServer.call(__MODULE__, {:normalize_zip, zipcode})
  end

  ## ------------------------------------------------- ##
  ##                   Server API                      ##
  ## ------------------------------------------------- ##
  @impl true
  def init(_opts) do
    Logger.info("ZipcodeManager started")
    file = "assets/data/population_by_zcta_2010.csv"
    state = File.stream!(file) |> CSV.decode!()
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    # action, response, new state(no change)
    {:reply, state, state}
  end

  def handle_call({:normalize_zip, zipcode}, _from, state) do
    total_population = check_population(zipcode, state)

    if total_population < 20_000 do
      {:reply, "00000", state}
    else
      {:reply, String.slice(zipcode, 0..2), state}
    end
  end

  @impl true
  def handle_cast(:reset_state, _state) do
    # note: no response
    # action, current state(set to empty map)
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  @impl true
  def terminate(reason, stats) do
    # We could write to a file, database etc
    IO.puts("server terminated because of #{inspect(reason)}")
    inspect(stats)
    :ok
  end

  @impl true
  def handle_info(msg, state) do
    IO.puts("received #{inspect(msg)}")
    {:noreply, state}
  end

  ## Private functions ##

  defp check_population(zipcode, state) do
    # "ZIP Codes should be stripped to the first three digits"
    z = String.slice(zipcode, 0..2)

    Stream.filter(state, fn [zip, _pop] -> String.slice(zip, 0..2) == z end)
    |> Enum.reduce(0, fn [_zip, pop], acc -> String.to_integer(pop) + acc end)
  end
end
