defmodule PingyWeb.ServerControllerTest do
  use PingyWeb.ConnCase

  alias Pingy.Servers

  @create_attrs %{ip: "some ip", password: "some password", username: "some username"}
  @update_attrs %{ip: "some updated ip", password: "some updated password", username: "some updated username"}
  @invalid_attrs %{ip: nil, password: nil, username: nil}

  def fixture(:server) do
    {:ok, server} = Servers.create_server(@create_attrs)
    server
  end

  describe "index" do
    test "lists all servers", %{conn: conn} do
      conn = get conn, server_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Servers"
    end
  end

  describe "new server" do
    test "renders form", %{conn: conn} do
      conn = get conn, server_path(conn, :new)
      assert html_response(conn, 200) =~ "New Server"
    end
  end

  describe "create server" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, server_path(conn, :create), server: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == server_path(conn, :show, id)

      conn = get conn, server_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Server"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, server_path(conn, :create), server: @invalid_attrs
      assert html_response(conn, 200) =~ "New Server"
    end
  end

  describe "edit server" do
    setup [:create_server]

    test "renders form for editing chosen server", %{conn: conn, server: server} do
      conn = get conn, server_path(conn, :edit, server)
      assert html_response(conn, 200) =~ "Edit Server"
    end
  end

  describe "update server" do
    setup [:create_server]

    test "redirects when data is valid", %{conn: conn, server: server} do
      conn = put conn, server_path(conn, :update, server), server: @update_attrs
      assert redirected_to(conn) == server_path(conn, :show, server)

      conn = get conn, server_path(conn, :show, server)
      assert html_response(conn, 200) =~ "some updated ip"
    end

    test "renders errors when data is invalid", %{conn: conn, server: server} do
      conn = put conn, server_path(conn, :update, server), server: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Server"
    end
  end

  describe "delete server" do
    setup [:create_server]

    test "deletes chosen server", %{conn: conn, server: server} do
      conn = delete conn, server_path(conn, :delete, server)
      assert redirected_to(conn) == server_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, server_path(conn, :show, server)
      end
    end
  end

  defp create_server(_) do
    server = fixture(:server)
    {:ok, server: server}
  end
end
