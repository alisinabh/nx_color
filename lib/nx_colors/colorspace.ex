defmodule NxColors.Colorspace do
  @moduledoc """
  Helpers and macros for defining colorspaces
  """

  defmacro __using__(_opts) do
    quote do
      import Nx.Defn
      import NxColors.Constant
      import NxColors.Colorspace

      require NxColors.Colorspace

      alias NxColors.Colorspace

      Module.register_attribute(__MODULE__, :accepted_colorspaces, accumulate: true)

      @before_compile NxColors.Colorspace
    end
  end

  defmacro defconv(params, do: block) do
    quote do
      from_colorspace = Keyword.fetch!(unquote(params), :from)
      @colorspace Module.concat(NxColors.Colorspace, from_colorspace)
      @accepted_colorspaces @colorspace

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
      def convert(%NxColors.Image{colorspace: colorspace} = image, opts) do
        with proxy when not is_nil(proxy) <-
               Enum.find(accepted_colorspaces(), &(colorspace in &1.accepted_colorspaces())),
             image = proxy.convert(image, opts) do
          convert(image, opts)
        else
          nil -> raise "Converting #{colorspace} to #{__MODULE__} is not supported"
        end
      end

      def accepted_colorspaces, do: unquote(accepted_colorspaces)
    end
  end
end
