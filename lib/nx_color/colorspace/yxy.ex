defmodule NxColor.Colorspace.Yxy do
  @moduledoc """
  Yxz Colorspace
  """

  use NxColor.Colorspace

  defconv from: XYZ do
    from_xyz(image.tensor)
  end

  defnp from_xyz(tensor) do
    x = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    z = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    sum = x + y + z

    [
      y,
      x / sum,
      y / sum
    ]
    |> Nx.concatenate(axis: -1)
  end
end
