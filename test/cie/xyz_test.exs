defmodule NxColors.CIE.XYZTest do
  use ExUnit.Case

  @image_rgb Nx.tensor([
               [
                 [255, 255, 255],
                 [0, 25, 255],
                 [255, 25, 0]
               ],
               [
                 [0, 25, 255],
                 [255, 255, 255],
                 [255, 25, 0]
               ]
             ])
  @image_xyz Nx.tensor([
               [
                 [95.0456, 100.0, 108.8754],
                 [18.38991129, 7.91212258, 95.13857011],
                 [41.59291129, 21.96232258, 2.04927011]
               ],
               [
                 [18.38991129, 7.91212258, 95.13857011],
                 [95.0456, 100.0, 108.8754],
                 [41.59291129, 21.96232258, 2.04927011]
               ]
             ])

  describe "from_rgb" do
    test "converts and rgb imaga to xyz" do
      @image_rgb
      |> NxColors.from_nx(channel: :last)
      |> NxColors.change_colorspace(NxColors.Colorspace.CIE.XYZ)
      |> NxColors.to_nx(channel: :last)
      |> approx_equal(@image_xyz)
    end
  end

  def approx_equal(t1, t2) do
    assert Nx.shape(t1) == Nx.shape(t2)

    t1
    |> Nx.subtract(t2)
    |> Nx.abs()
    |> Nx.less(1.0e-5)
    |> Nx.all()
    |> Nx.to_number()
    |> then(&assert &1 == 1)
  end
end
