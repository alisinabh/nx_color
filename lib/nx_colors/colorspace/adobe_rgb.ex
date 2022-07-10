defmodule NxColors.Colorspace.AdobeRGB do
  @moduledoc """
  Adobe RGB Colorspace
  """

  use NxColors.Colorspace

  defconv from: XYZ do
    from_xyz(image.tensor)
  end

  defnp from_xyz(tensor) do
    tensor = tensor / 100

    x = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    z = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [
      x * 2.0413690 + y * -0.5649464 + z * -0.3446944,
      x * -0.9692660 + y * 1.8760108 + z * 0.0415560,
      x * 0.0134474 + y * -0.1183897 + z * 1.0154096
    ]
    |> Nx.concatenate(axis: -1)
    |> Nx.power(1 / 2.19921875)
    |> Nx.multiply(255)
  end
end
