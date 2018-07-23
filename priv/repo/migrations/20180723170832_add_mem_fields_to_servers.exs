defmodule Pingy.Repo.Migrations.AddMemFieldsToServers do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      add :free_mem, :integer
      add :last_check_at, :utc_datetime
    end
  end
end
