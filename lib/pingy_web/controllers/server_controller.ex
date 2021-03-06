defmodule PingyWeb.ServerController do
  use PingyWeb, :controller

  alias Pingy.Servers
  alias Pingy.Servers.Server

  plug :set_timezone

  def index(conn, _params) do
    servers = Servers.list_servers()
    render(conn, "index.html", servers: servers)
  end

  def check(conn, %{"id" => id}) do
    server = Servers.get_server!(id)
    case Servers.check_server(server) do
      {:ok, _server} ->
        index(conn, %{})

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Server check failed.")
        |> redirect(to: server_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Servers.change_server(%Server{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"server" => server_params}) do
    case Servers.create_server(server_params) do
      {:ok, server} ->
        conn
        |> put_flash(:info, "Server created successfully.")
        |> redirect(to: server_path(conn, :show, server))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    server = Servers.get_server!(id)
    render(conn, "show.html", server: server)
  end

  def edit(conn, %{"id" => id}) do
    server = Servers.get_server!(id)
    changeset = Servers.change_server(server)
    render(conn, "edit.html", server: server, changeset: changeset)
  end

  def update(conn, %{"id" => id, "server" => server_params}) do
    server = Servers.get_server!(id)

    case Servers.update_server(server, server_params) do
      {:ok, server} ->
        conn
        |> put_flash(:info, "Server updated successfully.")
        |> redirect(to: server_path(conn, :show, server))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", server: server, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    server = Servers.get_server!(id)
    {:ok, _server} = Servers.delete_server(server)

    conn
    |> put_flash(:info, "Server deleted successfully.")
    |> redirect(to: server_path(conn, :index))
  end

  defp set_timezone(conn, _) do
    conn
    |> assign(:tz, Timex.Timezone.get("Europe/Moscow"))
  end
end
