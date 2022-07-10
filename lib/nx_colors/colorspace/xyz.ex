defmodule NxColors.Colorspace.XYZ do
  @moduledoc """
  XYZ Colorspace
  """

  use NxColors.Colorspace

  defconv from: RGB do
    from_rgb(image.tensor)
  end

  defconv from: CIE.Lab do
    illuminant_ref = opts[:illuminant_reference] || illuminant_reference()
    from_lab(image.tensor, illuminant_ref)
  end

  defconv from: AdobeRGB do
    from_argb(image.tensor)
  end

  defconv from: Yxy do
    from_yxy(image.tensor)
  end

  defnp from_rgb(tensor) do
    tensor = tensor / 255
    mask = tensor > rgb_xyz_threshold()

    gr = Nx.power((tensor + 0.055) * mask / 1.055, 2.4) * mask
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

    (cube * mask + le) * illuminant_reference
  end

  defnp from_argb(tensor) do
    tensor =
      (tensor / 255)
      |> Nx.power(2.19921875)
      |> Nx.multiply(100)

    r = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    g = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    b = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [
      r * 0.5767309 + g * 0.1855540 + b * 0.1881852,
      r * 0.2973769 + g * 0.6273491 + b * 0.0752741,
      r * 0.0270343 + g * 0.0706872 + b * 0.9911085
    ]
    |> Nx.concatenate(axis: -1)
  end

  defnp from_yxy(tensor) do
    y = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    x = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    yp = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [
      x * y / yp,
      y,
      (1 - x - yp) * y / yp
    ]
    |> Nx.concatenate(axis: -1)
  end
end
