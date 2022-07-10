defmodule NxColors.Colorspace.CIE.LCH do
  @moduledoc """
  CIE L*CH° Colorspace
  """

  use NxColors.Colorspace

  defconv from: CIE.Lab do
    from_lab(image.tensor)
  end

  defnp from_lab(tensor) do
    l = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    a = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    b = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    h = Nx.atan2(b, a) / pi() * 180

    [
      l,
      Nx.sqrt(Nx.power(a, 2) + Nx.power(b, 2)),
      h + (h < 0) * 360
    ]
    |> Nx.concatenate(axis: -1)
  end

  defnp from_lab_old(tensor) do
    l = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    a = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    b = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    h = Nx.atan2(b, a) * 180 / pi()

    [
      l,
      Nx.sqrt(Nx.power(a, 2) + Nx.power(b, 2)),
      h + (h < 0) * 360
    ]
    |> Nx.concatenate(axis: -1)
  end
end
