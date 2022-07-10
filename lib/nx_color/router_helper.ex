defmodule NxColor.Router.Helper do
  @moduledoc false

  def get_route(from, to, acc \\ []) do
    to_accepted_colorspaces = to.accepted_colorspaces()

    if from in to_accepted_colorspaces do
      [to | acc]
    else
      to_accepted_colorspaces
      |> Enum.reject(&(&1 in acc))
      |> Enum.map(fn c ->
        get_route(from, c, [to | acc])
      end)
      |> Enum.reject(&(Enum.count(&1) == 0))
      |> Enum.sort_by(&Enum.count/1)
      |> List.first()
      |> then(&(&1 || []))
    end
  end
end
