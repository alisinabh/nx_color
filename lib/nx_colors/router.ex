defmodule NxColors.Router do
  @moduledoc """
  Colorspace conversion router
  """

  alias NxColors.Colorspace

  require NxColors.Router.Helper
  import NxColors.Router.Helper

  @colorspaces [
    Colorspace.AdobeRGB,
    Colorspace.CIE.LCH,
    Colorspace.CIE.Lab,
    Colorspace.CMY,
    Colorspace.CMYK,
    Colorspace.RGB,
    Colorspace.XYZ,
    Colorspace.Yxy
  ]

  Enum.each(@colorspaces, fn colorspace ->
    Enum.each(@colorspaces -- [colorspace], fn
      to_colorspace ->
        route = get_route(colorspace, to_colorspace)

        def get_route(unquote(colorspace), unquote(to_colorspace)) do
          unquote(route)
        end
    end)
  end)
end
