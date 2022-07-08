defmodule NxColors.RGB do
  @moduledoc """
  RGB Colorspace
  """

  alias NxColors.CIE.XYZ

  defdelegate from_xyz(tensor), to: XYZ, as: :to_rgb
end
