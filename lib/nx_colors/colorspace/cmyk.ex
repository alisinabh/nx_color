defmodule NxColors.Colorspace.CMYK do
  @moduledoc """
  CMYK Colorspace
  """

  use NxColors.Colorspace

  defconv from: CMY do
    from_cmy(image.tensor)
  end

  defnp from_cmy(tensor) do
    c = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    m = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    k =
      (c == c)
      |> min(c)
      |> min(m)
      |> min(y)

    mask = k != 1

    kp = 1 - k

    [
      Nx.select(mask, (c - k) * mask / kp, 0),
      Nx.select(mask, (m - k) * mask / kp, 0),
      Nx.select(mask, (y - k) * mask / kp, 0),
      k
    ]
    |> Nx.concatenate(axis: -1)
  end
end
