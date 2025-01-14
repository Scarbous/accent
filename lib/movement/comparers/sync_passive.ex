defmodule Movement.Comparers.SyncPassive do
  @behaviour Movement.Comparer

  alias Movement.Mappers.Operation, as: OperationMapper

  alias Movement.{
    Operation,
    TranslationComparer
  }

  @doc """
    ## Examples

    iex> suggested_translation = %Movement.SuggestedTranslation{key: "a", text: "foo"}
    iex> Movement.Comparers.SyncPassive.compare(nil, suggested_translation).action
    "new"
    iex> translation = %Accent.Translation{removed: true, key: "a", proposed_text: "bar", corrected_text: "baz"}
    iex> suggested_translation = %Movement.SuggestedTranslation{key: "a", text: "foo"}
    iex> Movement.Comparers.SyncPassive.compare(translation, suggested_translation).action
    "renew"
    iex> translation = %Accent.Translation{marked_as_removed: true, key: "a", proposed_text: "bar", corrected_text: "baz"}
    iex> suggested_translation = %Movement.SuggestedTranslation{key: "a", text: "foo"}
    iex> Movement.Comparers.SyncPassive.compare(translation, suggested_translation).action
    "remove"
    iex> translation = %Accent.Translation{key: "a", proposed_text: "bar", corrected_text: "baz"}
    iex> suggested_translation = %Movement.SuggestedTranslation{key: "a", text: "foo"}
    iex> Movement.Comparers.SyncPassive.compare(translation, suggested_translation).action
    "noop"
  """
  def compare(translation, suggested_translation) do
    case TranslationComparer.compare(translation, suggested_translation.text) do
      {action, text} when action in ~w(new renew remove) ->
        suggested_translation = %{suggested_translation | text: text}

        OperationMapper.map(action, translation, suggested_translation)

      {_, text} ->
        %Operation{action: "noop", key: suggested_translation.key, text: text}
    end
  end
end
