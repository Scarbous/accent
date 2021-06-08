defmodule Accent.Repo.Migrations.AddOptionsOnOperations do
  use Ecto.Migration

  def change do
    alter table(:operations) do
      add(:options, {:array, :string}, null: false, default: [])
    end
  end
end
