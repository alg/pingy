defmodule Pingy.Servers do
  @moduledoc """
  The Servers context.
  """

  import Ecto.Query, warn: false
  alias Pingy.Repo

  alias Pingy.Servers.Server

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers()
      [%Server{}, ...]

  """
  def list_servers do
    Repo.all(Server)
  end

  def list_outdated_servers() do
    time = Timex.subtract(Timex.now(), Timex.Duration.from_seconds(30))

    q =
      from s in Server,
        where: is_nil(s.last_check_at) or s.last_check_at < ^time

    Repo.all(q)
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(123)
      %Server{}

      iex> get_server!(456)
      ** (Ecto.NoResultsError)

  """
  def get_server!(id), do: Repo.get!(Server, id)

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(%{field: value})
      {:ok, %Server{}}

      iex> create_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
  end

  def check_server(%Server{ip: ip, username: username, password: password} = server) do
    t = Task.async(Pingy.CheckerTask, :run, [ip, username, password])
    case Task.await(t) do
      {:ok, free_mem} ->
        update_server(server, %{free_mem: free_mem, last_check_at: DateTime.utc_now()})

      {:error, _domain, _reason} = e ->
        e
    end
  end

  def check_outdated_servers() do
    IO.puts "--------------------- Checking outdated servers"

    list_outdated_servers()
    |> Enum.each(&check_server/1)
  end

  @doc """
  Deletes a Server.

  ## Examples

      iex> delete_server(server)
      {:ok, %Server{}}

      iex> delete_server(server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_server(%Server{} = server) do
    Repo.delete(server)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(server)
      %Ecto.Changeset{source: %Server{}}

  """
  def change_server(%Server{} = server) do
    Server.changeset(server, %{})
  end
end
