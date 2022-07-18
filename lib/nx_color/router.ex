defmodule NxColor.Router do
  @moduledoc """
  Colorspace conversion router
  """

  alias NxColor.Colorspace

  require NxColor.Router.Helper
  import NxColor.Router.Helper

  @type route_error :: :invalid_conversion | :invalid_colorspace

  @colorspaces [
    Colorspace.AdobeRGB,
    Colorspace.CIE.LCH,
    Colorspace.CIE.Lab,
    Colorspace.CMY,
    Colorspace.CMYK,
    Colorspace.Grayscale,
    Colorspace.RGB,
    Colorspace.XYZ,
    Colorspace.Yxy
  ]

  @doc """
  Returns the route path to convert a colorspace to another
  """
  @spec get_route(atom(), atom()) :: {:ok, [atom()]} | {:error, :invalid_color_conversion}
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

  def get_route(_from, _to) do
    {:error, :invalid_colorspace}
  end
end
