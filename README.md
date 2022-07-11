# NxColor

[![Package](https://img.shields.io/badge/-Package-important)](https://hex.pm/packages/nx_color) [![Documentation](https://img.shields.io/badge/-Documentation-blueviolet)](https://hexdocs.pm/nx_color)

Colorspace conversion in Elixir Nx.

With NxColor you can convert images (to be precise, pixels) between various colorspaces
like RGB, CMYK or CIE-Lab.

Since this is implemented using Elixir Nx, It should be really fast.

## Installation

NxColor can be installed by adding `nx_color` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nx_color, "~> 0.0.1-dev"}
  ]
end
```

## Usage

Using libraries like [stb_image](https://hex.pm/packages/stb_image) or using an already loaded
image or images in an Nx.Tensor, You can import them into NxColor using the `NxColor.from_nx`
function.

```elixir
stb_image = StbImage.read_file!("image.jpg")

image =
  stb_image
  |> StbImage.to_nx()
  |> NxColor.from_nx(colorspace: NxColor.Colorspace.RGB, channel: :last)
```

Then you can use `NxColor.change_colorspace` to actually convert the colorspace of the image.

You can see the list of all available colorspaces in the [documentation](https://hexdocs.pm/nx_color/NxColor.html).

```elixir
image = NxColor.change_colorspace(image, NxColor.Colorspace.CMYK)
```

After you are done with the conversions, You can convert your image back to an Nx tensor.

```elixir
tensor = NxColor.to_nx(image, channel: :last)
```

### The channel option

Usually there are two ways of representing images in tensors.

Let's say we have a 32 x 32 image in the RGB colorspace. Each pixel in that colorspace
is represented by 3 different number. **R**ed **G**reen and **B**lue.

The first way is if we encode the colors (the channel) as the **first** dimension in each image.
So the shape for our image tensor would be: `{3, 32, 32}`

The second way is if we encode the colors (the channel) as the **last** dimension in each image.
So the shape of our image tensor in this case would be: `{32, 32, 3}`

In NxColor you can choose between these two based on you input data and also your use-case.
Simply set the `channel` option in `NxColor.from_nx` and `NxColor.to_nx` either to `:first` or `:last`.
