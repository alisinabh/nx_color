defmodule NxColors.ColorspaceTestHelper do
  defmacro __using__(_env) do
    module = __MODULE__

    quote do
      require unquote(module)
      import unquote(module)

      alias NxColors.Colorspace

      def approx_equal(t1, t2, opts \\ []) do
        precision = Nx.power(10, Keyword.get(opts, :precision, 4))
        assert Nx.shape(t1) == Nx.shape(t2)

        t1 =
          t1
          |> Nx.multiply(precision)
          |> Nx.round()
          |> Nx.divide(precision)

        t2 =
          t2
          |> Nx.multiply(precision)
          |> Nx.round()
          |> Nx.divide(precision)

        assert t1 == t2
      end
    end
  end

  defmacro colorspacetest(colorspace, opts \\ []) do
    quote bind_quoted: [colorspace: colorspace, opts: opts], location: :keep do
      accepted_colorspaces = colorspace.accepted_colorspaces()
      ["NxColors", "Colorspace" | name] = Module.split(colorspace)
      path = Enum.join(name, "/") |> String.downcase()
      name = Enum.join(name, ".")

      Enum.map(accepted_colorspaces, fn to_colorspace ->
        ["NxColors", "Colorspace" | to_name] = Module.split(to_colorspace)
        to_path = Enum.join(to_name, "/") |> String.downcase()
        to_name = Enum.join(to_name, ".")

        files = File.ls!(Path.join("test/fixtures", path))

        test "conversions from #{name} to #{to_name}" do
          Enum.each(unquote(files), fn file ->
            source_tensor =
              File.read!(Path.join(["test/fixtures", unquote(path), file])) |> Nx.deserialize()

            target_tensor =
              File.read!(Path.join(["test/fixtures", unquote(to_path), file])) |> Nx.deserialize()

            source_tensor
            |> NxColors.from_nx(channel: :last, colorspace: unquote(colorspace))
            |> NxColors.change_colorspace(unquote(to_colorspace))
            |> NxColors.to_nx(channel: :last)
            |> approx_equal(target_tensor, unquote(opts))
          end)
        end
      end)
    end
  end
end
