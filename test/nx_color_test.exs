defmodule NxColorTest do
  use ExUnit.Case
  use NxColor.ColorspaceTestHelper

  doctest NxColor

  colorspacetest(Colorspace.AdobeRGB)
  colorspacetest(Colorspace.CIE.LCH)
  colorspacetest(Colorspace.CIE.Lab)
  colorspacetest(Colorspace.CMY)
  colorspacetest(Colorspace.CMYK)
  colorspacetest(Colorspace.RGB)
  colorspacetest(Colorspace.XYZ)
  colorspacetest(Colorspace.Yxy)
end
