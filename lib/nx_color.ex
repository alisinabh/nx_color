defmodule NxColor do
  @moduledoc """
  NxColor implements diffenret colorspaces in Using Nx tensors.

  This module helps you to load image data and convert it to different colorspaces.
  """

  alias NxColor.{Colorspace, Image, Router}

  @doc """
  Creates a NxColor.Image struct from an Nx tensor.

  ## Parameters
  - tensor: The input image or images.
  - opts: Options keyword list.
    - channel: Determines in which dimention the color channel is in the given tensor. 
      Can be either `:last` or `:first`. Defaults to `:last`
      Note that `:first` means first dimension in each image.
    - colorspace: In which colorspace is the current image. 
      Defaults to: NxColor.Colorspace.RGB

  ## Examples

      iex> NxColor.from_nx(Nx.tensor([[[255, 255, 255]]]))
      #NxColor.Image<Elixir.NxColor.Colorspace.RGB>
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
  Returns the tensor from an NxColor.Image struct.

  ## Parameters
  - image: an NxColor.Image struct.
  - opts: Options keyword list.
    - channel: Determines in which dimension the color channel should be in the output tensor.
      Can be either `:first` or `:last`. Defaults to `:last`
      Note that `:first` means first dimension in each image.
  """
  @spec to_nx(NxColor.Image.t(), Keyword.t()) :: Nx.Tensor.t()
  def to_nx(%Image{tensor: tensor}, opts \\ []) do
    channel = Keyword.get(opts, :channel, :last)
    reverse_channel(tensor, channel, :output)
  end

  def change_colorspace!(image, target_colorspace, opts \\ []) do
    {:ok, image} = change_colorspace(image, target_colorspace, opts)
    image
  end

  @doc """
  Changes the colorspace of a given NxColor.Image struct to the `target_colorspace`.

  ## Parameters
  - image: an NxColor.Image struct.
  - target_colorspace: Module of the colorspace you want to convert your image colorspace into.
  - opts: Colorspace specific options. See target colorspace module documentation for more info.
  """
  @spec change_colorspace(NxColor.Image.t(), atom(), Keyword.t()) ::
          {:ok, NxColor.Image.t()} | {:error, Router.route_error()}
  def change_colorspace(%Image{colorspace: colorspace} = image, target_colorspace, opts \\ []) do
    with {:ok, route} <- Router.get_route(colorspace, target_colorspace) do
      change_colorspace_with_route(image, route, opts)
    end
  end

  def change_colorspace_with_route(image, route, opts \\ [])

  def change_colorspace_with_route(%Image{} = image, [colorspace | t], opts) do
    colorspace.convert(image, opts)
    |> change_colorspace_with_route(t)
  end

  def change_colorspace_with_route(%Image{} = image, [], _opts) do
    {:ok, image}
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
