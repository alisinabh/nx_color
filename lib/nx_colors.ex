defmodule NxColors do
  @moduledoc """
  NxColors implements diffenret colorspaces in Using Nx tensors.

  This module helps you to load image data and convert it to different colorspaces.
  """

  alias NxColors.{Colorspace, Image, Router}

  @doc """
  Creates a NxColor.Image struct from an Nx tensor.

  ## Parameters
  - tensor: The input image or images.
  - opts: Options keyword list.
    - channel: Determines in which dimention the color channel is in the given tensor. 
      Can be either `:last` or `:first`. Defaults to `:last`
      Note that `:first` means first dimension in each image.
    - colorspace: In which colorspace is the current image. 
      Defaults to: NxColors.Colorspace.RGB

  ## Examples

      iex> NxColors.from_nx(Nx.tensor([[[255, 255, 255]]]))
      #NxColors.Image<Elixir.NxColors.Colorspace.RGB>
  """
  @spec from_nx(Nx.Tensor.t(), Keyword.t()) :: Image.t()
  def from_nx(tensor, opts \\ []) do
    channel = Keyword.get(opts, :channel, :last)
    colorspace = Keyword.get(opts, :colorspace, Colorspace.RGB)

    tensor
    |> reverse_channel(channel, :input)
    |> Image.new(colorspace)
  end

  @doc """
  Returns the tensor from an NxColors.Image struct.

  ## Parameters
  - image: an NxColors.Image struct.
  - opts: Options keyword list.
    - channel: Determines in which dimension the color channel should be in the output tensor.
      Can be either `:first` or `:last`. Defaults to `:last`
      Note that `:first` means first dimension in each image.
  """
  @spec to_nx(NxColors.Image.t(), Keyword.t()) :: Nx.Tensor.t()
  def to_nx(%Image{tensor: tensor}, opts \\ []) do
    channel = Keyword.get(opts, :channel, :last)
    reverse_channel(tensor, channel, :output)
  end

  @doc """
  Changes the colorspace of a given NxColors.Image struct to the `target_colorspace`.

  ## Parameters
  - image: an NxColors.Image struct.
  - target_colorspace: Module of the colorspace you want to convert your image colorspace into.
  - opts: Colorspace specific options. See target colorspace module documentation for more info.
  """
  @spec change_colorspace(NxColors.Image.t(), atom(), Keyword.t()) ::
          NxColors.Image.t() | no_return
  def change_colorspace(%Image{colorspace: colorspace} = image, target_colorspace, opts \\ []) do
    colorspace
    |> Router.get_route(target_colorspace)
    |> Enum.reduce(image, & &1.convert(&2, opts))
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
