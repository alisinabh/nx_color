defmodule NxColorsTest do
  use ExUnit.Case
  use NxColors.ColorspaceTestHelper

  doctest NxColors

  colorspacetest(Colorspace.AdobeRGB)
  colorspacetest(Colorspace.CIE.LCH, precision: 3)
  colorspacetest(Colorspace.CIE.Lab, precision: 3)
  colorspacetest(Colorspace.CMY)
  colorspacetest(Colorspace.CMYK)
  colorspacetest(Colorspace.RGB)
  colorspacetest(Colorspace.XYZ)
  colorspacetest(Colorspace.Yxy)
end
