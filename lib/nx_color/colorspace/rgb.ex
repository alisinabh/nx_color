defmodule NxColor.Colorspace.RGB do
  @moduledoc """
  RGB Colorspace
  """

  use NxColor.Colorspace

  defconv from: XYZ do
    from_xyz(image.tensor)
  end

  defconv from: CMY do
    from_cmy(image.tensor)
  end

  defnp from_xyz(tensor) do
    tensor =
      (tensor / 100)
      |> Nx.dot(Nx.LinAlg.invert(Nx.tensor(rgb_to_xyz_constants())))

    mask = tensor > xyz_rgb_threshold()

    gr = (1.055 * Nx.power(tensor * mask, 1 / 2.4) - 0.055) * mask
    le = tensor * 12.92 * (mask == 0)

    Nx.round((gr + le) * 255) |> Nx.as_type({:u, 8})
  end

  defnp from_cmy(tensor) do
    c = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    m = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [
      (1 - c) * 255,
      (1 - m) * 255,
      (1 - y) * 255
    ]
    |> Nx.concatenate(axis: -1)
  end
end
