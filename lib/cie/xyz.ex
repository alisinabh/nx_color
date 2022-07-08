defmodule NxColors.CIE.XYZ do
  @moduledoc """
  CIE XYZ Colorspace
  """

  import Nx.Defn

  alias NxColors.CIE.Lab

  @rgb_to_xyz_constants [
    [0.412453, 0.212671, 0.019334],
    [0.357580, 0.715160, 0.119193],
    [0.180423, 0.072169, 0.950227]
  ]
  @rgb_xyz_threshold 0.04045
  @xyz_rgb_threshold 0.0031308

  defdelegate from_lab(tensor), to: Lab, as: :to_xyz

  defn from_rgb(tensor) do
    tensor = tensor / 255
    mask = tensor > @rgb_xyz_threshold

    gr = Nx.power((tensor + 0.055) / 1.055, 2.4) * mask
    le = tensor / 12.92 * (mask == 0)

    Nx.dot((gr + le) * 100, Nx.tensor(@rgb_to_xyz_constants))
  end

  defn to_rgb(tensor) do
    tensor =
      (tensor / 100)
      |> Nx.dot(Nx.LinAlg.invert(Nx.tensor(@rgb_to_xyz_constants)))

    mask = tensor > @xyz_rgb_threshold

    gr = (1.055 * Nx.power(tensor, 1 / 2.4) - 0.055) * mask
    le = tensor * 12.92 * (mask == 0)

    (gr + le) * 255
  end
end
