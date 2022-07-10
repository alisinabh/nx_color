defmodule NxColor.ColorspaceTestHelper do
  defmacro __using__(_env) do
    module = __MODULE__

    quote do
      require unquote(module)
      import unquote(module)
      import NxColor.NxTestHelper

      alias NxColor.Colorspace
    end
  end

  defmacro colorspacetest(colorspace, opts \\ []) do
    quote bind_quoted: [colorspace: colorspace, opts: opts], location: :keep do
      accepted_colorspaces = colorspace.accepted_colorspaces()
      ["NxColor", "Colorspace" | name] = Module.split(colorspace)
      path = Enum.join(name, "/") |> String.downcase()
      name = Enum.join(name, ".")

      Enum.map(accepted_colorspaces, fn to_colorspace ->
        ["NxColor", "Colorspace" | to_name] = Module.split(to_colorspace)
        to_path = Enum.join(to_name, "/") |> String.downcase()
        to_name = Enum.join(to_name, ".")

        files = File.ls!(Path.join("test/fixtures", path))

        test "conversions from #{name} to #{to_name}" do
          Enum.each(unquote(files), fn file ->
            source_tensor =
              File.read!(Path.join(["test/fixtures", unquote(path), file])) |> Nx.deserialize()

            target_tensor =
              File.read!(Path.join(["test/fixtures", unquote(to_path), file])) |> Nx.deserialize()

            opts =
              unquote(opts)
              |> Keyword.put_new(:atol, 1.0e-7)

            source_tensor
            |> NxColor.from_nx(channel: :last, colorspace: unquote(colorspace))
            |> NxColor.change_colorspace(unquote(to_colorspace))
            |> NxColor.to_nx(channel: :last)
            |> assert_all_close(target_tensor, opts)
          end)
        end
      end)
    end
  end
end
