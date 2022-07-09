defmodule NxColorsTest do
  use ExUnit.Case
  use NxColors.ColorspaceTestHelper

  doctest NxColors

  colorspacetest(Colorspace.RGB)
  colorspacetest(Colorspace.CIE.XYZ)
  colorspacetest(Colorspace.CIE.Lab)
end
