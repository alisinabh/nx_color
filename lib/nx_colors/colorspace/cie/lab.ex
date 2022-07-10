defmodule NxColors.Colorspace.CIE.Lab do
  @moduledoc """
  CIE L*a*b Colorspace
  """

  use NxColors.Colorspace

  defconv from: XYZ do
    illuminant_ref = opts[:illuminant_reference] || illuminant_reference()

    from_xyz(image.tensor, illuminant_ref)
  end

  defnp from_xyz(tensor, illuminant_reference) do
    tensor = tensor / illuminant_reference
    mask = tensor > lab_threshold()

    gr = Nx.cbrt(tensor) * mask
    le = (tensor * 24389 / 27 + 16) / 116 * (mask == 0)

    tensor = gr + le

    x = Nx.slice_along_axis(tensor, 0, 1, axis: -1)
    y = Nx.slice_along_axis(tensor, 1, 1, axis: -1)
    z = Nx.slice_along_axis(tensor, 2, 1, axis: -1)

    [y * 116 - 16, (x - y) * 500, (y - z) * 200]
    |> Nx.concatenate(axis: -1)
  end
end
