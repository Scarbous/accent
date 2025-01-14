defmodule Accent.Scopes.Language do
  import Ecto.Query, only: [from: 2]

  @doc """
  ## Examples

    iex> Accent.Scopes.Language.from_search(Accent.Language, "")
    Accent.Language
    iex> Accent.Scopes.Language.from_search(Accent.Language, nil)
    Accent.Language
  """
  @spec from_search(Ecto.Queryable.t(), any()) :: Ecto.Queryable.t()
  def from_search(query, nil), do: query
  def from_search(query, ""), do: query

  def from_search(query, term) do
    search = Accent.Scopes.Search.from_search(query, term, [:name, :slug])

    from(
      languages in search,
      order_by: [
        desc: languages.slug == ^term,
        desc: ilike(languages.slug, ^"#{term}%"),
        asc: fragment("character_length(?)", languages.slug)
      ]
    )
  end
end
