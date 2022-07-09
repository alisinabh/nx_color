defmodule NxColors do
  @moduledoc """
  Documentation for `NxColors`.
  """

  alias NxColors.{Colorspace, Image}

  def from_nx(tensor, opts \\ []) do
    channel = Keyword.get(opts, :channel, :first)
    colorspace = Keyword.get(opts, :colorspace, Colorspace.RGB)

    %Image{
      colorspace: colorspace,
      tensor: reverse_channel(tensor, channel, :input)
    }
  end

  def to_nx(%Image{tensor: tensor}, opts \\ []) do
    channel = Keyword.get(opts, :channel, :first)
    reverse_channel(tensor, channel, :output)
  end

  def change_colorspace(%Image{} = image, target_colorspace, opts \\ []) do
    target_colorspace.convert(image, opts)
  end

  defp reverse_channel(tensor, :last, _mode), do: tensor

  defp reverse_channel(tensor, :first, mode) do
    new_axes = reverse_axis(mode, Nx.rank(tensor))
    Nx.transpose(tensor, axes: new_axes)
  end

  defp reverse_axis(:input, rank) do
    Range.new(0, rank - 1)
    |> Enum.slide(-2..-1, -3)
  end

  defp reverse_axis(:output, rank) do
    Range.new(0, rank - 1)
    |> Enum.slide(-1, -3)
  end
end
