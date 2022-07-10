defmodule NxColor.Colorspace.CMY do
  @moduledoc """
  CMY Colorspace
  """

  use NxColor.Colorspace

  defconv from: RGB do
    from_rgb(image.tensor)
  end

  defconv from: CMYK do
    from_cmyk(image.tensor)
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

  defnp from_cmyk(tensor) do
    c = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    m = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 2, 1, axis: -1)
    k = Nx.slice_along_axis(tensor, 3, 1, axis: -1)

    [
      c * (1 - k) + k,
      m * (1 - k) + k,
      y * (1 - k) + k
    ]
    |> Nx.concatenate(axis: -1)
  end
end
