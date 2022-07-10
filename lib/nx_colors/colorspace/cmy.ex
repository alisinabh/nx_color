defmodule NxColors.Colorspace.CMY do
  @moduledoc """
  CMY Colorspace
  """

  use NxColors.Colorspace

  defconv from: RGB do
    from_rgb(image.tensor)
  end

  defnp from_rgb(tensor) do
    tensor = tensor / 255

    r = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    g = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    b = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [
      1 - r,
      1 - g,
      1 - b
    ]
    |> Nx.concatenate(axis: -1)
  end
end
