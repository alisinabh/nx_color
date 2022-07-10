defmodule NxColor.Router do
  @moduledoc """
  Colorspace conversion router
  """

  alias NxColor.Colorspace

  require NxColor.Router.Helper
  import NxColor.Router.Helper

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

  @doc """
  Returns the route path to convert a colorspace to another
  """
  @spec get_route(atom(), atom()) :: [atom()]
  def get_route(from, to)

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
