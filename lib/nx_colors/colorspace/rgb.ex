defmodule NxColors.Colorspace.RGB do
  @moduledoc """
  RGB Colorspace
  """

  use NxColors.Colorspace

  defconv from: CIE.XYZ do
    from_xyz(image.tensor)
  end

  defnp from_xyz(tensor) do
    tensor =
      (tensor / 100)
      |> Nx.dot(Nx.LinAlg.invert(Nx.tensor(rgb_to_xyz_constants())))

    mask = tensor > xyz_rgb_threshold()

    gr = (1.055 * Nx.power(tensor, 1 / 2.4) - 0.055) * mask
    le = tensor * 12.92 * (mask == 0)

    (gr + le) * 255
  end
end
