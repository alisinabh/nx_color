defmodule NxColors.Colorspace.CIE.XYZ do
  @moduledoc """
  CIE XYZ Colorspace
  """

  use NxColors.Colorspace

  defconv from: RGB do
    from_rgb(image.tensor)
  end

  defconv from: CIE.Lab do
    illuminant_ref = opts[:illuminant_reference] || illuminant_reference()
    from_lab(image.tensor, illuminant_ref)
  end

  defnp from_rgb(tensor) do
    tensor = tensor / 255
    mask = tensor > rgb_xyz_threshold()

    gr = Nx.power((tensor + 0.055) / 1.055, 2.4) * mask
    le = tensor / 12.92 * (mask == 0)

    Nx.dot((gr + le) * 100, Nx.tensor(rgb_to_xyz_constants()))
  end

  defnp from_lab(tensor, illuminant_reference) do
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
    mask = cube > lab_threshold()
    le = (tensor - 16 / 116) / 7.787 * (mask == 0)

    (cube * mask + le) * Nx.tensor(illuminant_reference)
  end
end
