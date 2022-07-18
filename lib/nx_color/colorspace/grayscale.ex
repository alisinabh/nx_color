defmodule NxColor.Colorspace.Grayscale do
  @moduledoc """
  Grayscale Colorspace
  """

  use NxColor.Colorspace

  defconv from: CIE.Lab do
    image.tensor
    |> Nx.slice_along_axis(0, 1, axis: -1)
    |> Nx.multiply(255)
    |> Nx.divide(100)
    |> Nx.as_type({:u, 8})
  end
end
