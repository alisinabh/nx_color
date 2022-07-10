defmodule NxColor.Colorspace do
  @moduledoc """
  Helpers and macros for defining colorspaces
  """

  @callback convert(image :: NxColor.Image.t(), opts :: Keyword.t()) :: NxColor.Image.t()

  @callback accepted_colorspaces() :: [atom()]

  defmacro __using__(_opts) do
    quote do
      import Nx.Defn
      import NxColor.Constant
      import NxColor.Colorspace

      require NxColor.Colorspace

      alias NxColor.Colorspace

      @behaviour NxColor.Colorspace

      Module.register_attribute(__MODULE__, :accepted_colorspaces, accumulate: true)

      @before_compile NxColor.Colorspace
    end
  end

  defmacro defconv(params, do: block) do
    quote do
      from_colorspace = Keyword.fetch!(unquote(params), :from)
      @colorspace Module.concat(NxColor.Colorspace, from_colorspace)
      @accepted_colorspaces @colorspace

      @impl true
      @spec convert(NxColor.Image.t(), Keyword.t()) :: NxColor.Image.t()
      def convert(
            %NxColor.Image{colorspace: @colorspace} = var!(image),
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
