defmodule NxColorsTest do
  use ExUnit.Case
  use NxColors.ColorspaceTestHelper

  doctest NxColors

  colorspacetest(Colorspace.AdobeRGB)
  colorspacetest(Colorspace.CIE.Lab)
  colorspacetest(Colorspace.CIE.XYZ)
  colorspacetest(Colorspace.RGB)
end
