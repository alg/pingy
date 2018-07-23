defmodule Pingy.CheckerTask do
  use Task

  def start_link(ip, username, password) do
    Task.start_link(__MODULE__, :run, [ip, username, password])
  end

  def run(ip, username, password) do
    # {:ok, free_mem}
    # {:error, :connection, "Timeout"}
    # {:error, :authorization, "Password is incorrect"}

    case SSHEx.connect ip: ip, user: username, password: password do
      {:ok, conn} ->
        conn
        |> SSHEx.cmd!('free')
        |> parse_output()

      {:error, reason} ->
        {:error, :connection, reason}
    end
  end

  def parse_output(res) do
    {num, _} =
      res
      |> String.split("\n")
      |> Enum.at(1)
      |> String.split(" ", trim: true)
      |> Enum.at(3)
      |> Integer.parse()

    {:ok, num}
  end

end

