defmodule NxColor.Image do
  @moduledoc """
  Image struct which holds the data for the images
  """
  @enforce_keys [:colorspace, :tensor]
  defstruct [:colorspace, :tensor]

  @type t :: %__MODULE__{
          tensor: Nx.Tensor.t(),
          colorspace: atom()
        }

  @doc """
  Creates a new NxColor Image struct from a tensor and a colorspace
  """
  def new(%Nx.Tensor{} = image_tensor, colorspace) do
    %__MODULE__{tensor: image_tensor, colorspace: colorspace}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%NxColor.Image{colorspace: colorspace}, opts) do
      force_unfit(
        concat([
          color("#NxColor.Image<", :map, opts),
          color(to_string(colorspace), :atom, opts),
          color(">", :map, opts)
        ])
      )
    end
  end
end
