defmodule NxColors do
  @moduledoc """
  Documentation for `NxColors`.
  """

  alias NxColors.RGB
  alias NxColors.CIE.{XYZ, Lab}

  @conversions %{
    RGB => [XYZ],
    XYZ => [Lab, RGB],
    Lab => [XYZ]
  }

  Enum.each(@conversions, fn {from, tos} ->
    Enum.each(tos, fn to ->
      from_str = Module.split(from) |> List.last()
      to_str = Module.split(to) |> List.last()

      fun_name = "#{from_str}_to_#{to_str}" |> String.downcase() |> String.to_atom()
      mod_fun_name = "from_#{from_str}" |> String.downcase() |> String.to_atom()

      def unquote(fun_name)(tensor) do
        unquote(to).unquote(mod_fun_name)(tensor)
      end

      @conversions
      |> Map.fetch!(to)
      |> Enum.reject(&(&1 == from))
      |> Enum.each(fn proxy_to ->
        proxy_to_str = Module.split(proxy_to) |> List.last()
        fun_name = "#{from_str}_to_#{proxy_to_str}" |> String.downcase() |> String.to_atom()
        proxy_mod_fun_name = "from_#{to_str}" |> String.downcase() |> String.to_atom()

        def unquote(fun_name)(tensor) do
          unquote(to).unquote(mod_fun_name)(tensor)
          |> unquote(proxy_to).unquote(proxy_mod_fun_name)()
        end
      end)
    end)
  end)
end
