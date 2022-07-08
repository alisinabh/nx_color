defmodule NxColors.CIE.Lab do
  @moduledoc """
  CIE L*a*b Colorspace
  """

  import Nx.Defn

  @d65_constants [95.047, 100.0, 108.883]
  @lab_threshold 0.008856

  defn from_xyz(tensor) do
    tensor = tensor / Nx.tensor(@d65_constants)
    mask = tensor > @lab_threshold

    gr = Nx.cbrt(tensor) * mask
    le = (tensor * 7.787 + 16 / 116) * (mask == 0)

    tensor = gr + le

    x = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    z = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [y * 116 - 16, (x - y) * 500, (y - z) * 200]
    |> Nx.concatenate(axis: -1)
  end

  defn to_xyz(tensor) do
    l = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    a = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    b = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    y = (l + 16) / 116
    x = a / 500 + y
    z = y - b / 200

    tensor =
      [x, y, z]
      |> Nx.concatenate(axis: -1)

    cube = Nx.power(tensor, 3)
    mask = cube > @lab_threshold
    le = (tensor - 16 / 116) / 7.787 * (mask == 0)

    (cube * mask + le) * Nx.tensor(@d65_constants)
  end
end
