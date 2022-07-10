defmodule NxColors.Colorspace do
  @moduledoc """
  Helpers and macros for defining colorspaces
  """

  @callback convert(image :: NxColors.Image.t(), opts :: Keyword.t()) :: NxColors.Image.t()

  @callback accepted_colorspaces() :: [atom()]

  defmacro __using__(_opts) do
    quote do
      import Nx.Defn
      import NxColors.Constant
      import NxColors.Colorspace

      require NxColors.Colorspace

      alias NxColors.Colorspace

      @behaviour NxColors.Colorspace

      Module.register_attribute(__MODULE__, :accepted_colorspaces, accumulate: true)

      @before_compile NxColors.Colorspace
    end
  end

  defmacro defconv(params, do: block) do
    quote do
      from_colorspace = Keyword.fetch!(unquote(params), :from)
      @colorspace Module.concat(NxColors.Colorspace, from_colorspace)
      @accepted_colorspaces @colorspace

      @impl true
      @spec convert(NxColors.Image.t(), Keyword.t()) :: NxColors.Image.t()
      def convert(
            %NxColors.Image{colorspace: @colorspace} = var!(image),
            var!(opts)
          ) do
        _ = var!(opts)
        %{var!(image) | colorspace: __MODULE__, tensor: unquote(block)}
      end
    end
  end

  defmacro __before_compile__(%{module: module}) do
    accepted_colorspaces = Module.get_attribute(module, :accepted_colorspaces)

    quote do
      @impl true
      def accepted_colorspaces, do: unquote(accepted_colorspaces)
    end
  end
end
