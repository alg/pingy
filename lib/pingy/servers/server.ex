defmodule Pingy.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset


  schema "servers" do
    field :ip, :string
    field :password, :string
    field :username, :string
    field :free_mem, :integer
    field :last_check_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:ip, :username, :password, :free_mem, :last_check_at])
    |> validate_required([:ip, :username, :password])
  end
end
