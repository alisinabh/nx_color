defmodule NxColors.Constant do
  @moduledoc """
  Constants used for conversions
  """

  import Nx.Defn

  defn(rgb_to_xyz_constants,
    do: [
      [0.4124564, 0.2126729, 0.0193339],
      [0.3575761, 0.7151522, 0.1191920],
      [0.1804375, 0.0721750, 0.9503041]
    ]
  )

  defn(rgb_xyz_threshold, do: 0.04045)
  defn(xyz_rgb_threshold, do: 0.0031308)
  defn(lab_threshold, do: 216 / 24389)

  @illuminant_references [
    %{
      illuminant: "a",
      cie1931: [109.850, 100.000, 35.585],
      cie1964: [111.144, 100.000, 35.200],
      description: "Incandescent/tungsten"
    },
    %{
      illuminant: "b",
      cie1931: [99.0927, 100.000, 85.313],
      cie1964: [99.178, 100.000, 84.3493],
      description: "Old direct sunlight at noon"
    },
    %{
      illuminant: "c",
      cie1931: [98.074, 100.000, 118.232],
      cie1964: [97.285, 100.000, 116.145],
      description: "Old daylight"
    },
    %{
      illuminant: "d50",
      cie1931: [96.422, 100.000, 82.521],
      cie1964: [96.720, 100.000, 81.427],
      description: "ICC profile PCS"
    },
    %{
      illuminant: "d55",
      cie1931: [95.682, 100.000, 92.149],
      cie1964: [95.799, 100.000, 90.926],
      description: "Mid-morning daylight"
    },
    %{
      illuminant: "d65",
      cie1931: [95.047, 100.000, 108.883],
      cie1964: [94.811, 100.000, 107.304],
      description: "Daylight, sRGB, Adobe-RGB"
    },
    %{
      illuminant: "d75",
      cie1931: [94.972, 100.000, 122.638],
      cie1964: [94.416, 100.000, 120.641],
      description: "North sky daylight"
    },
    %{
      illuminant: "e",
      cie1931: [100.000, 100.000, 100.000],
      cie1964: [100.000, 100.000, 100.000],
      description: "Equal energy"
    },
    %{
      illuminant: "f1",
      cie1931: [92.834, 100.000, 103.665],
      cie1964: [94.791, 100.000, 103.191],
      description: "Daylight Fluorescent"
    },
    %{
      illuminant: "f2",
      cie1931: [99.187, 100.000, 67.395],
      cie1964: [103.280, 100.000, 69.026],
      description: "Cool fluorescent"
    },
    %{
      illuminant: "f3",
      cie1931: [103.754, 100.000, 49.861],
      cie1964: [108.968, 100.000, 51.965],
      description: "White Fluorescent"
    },
    %{
      illuminant: "f4",
      cie1931: [109.147, 100.000, 38.813],
      cie1964: [114.961, 100.000, 40.963],
      description: "Warm White Fluorescent"
    },
    %{
      illuminant: "f5",
      cie1931: [90.872, 100.000, 98.723],
      cie1964: [93.369, 100.000, 98.636],
      description: "Daylight Fluorescent"
    },
    %{
      illuminant: "f6",
      cie1931: [97.309, 100.000, 60.191],
      cie1964: [102.148, 100.000, 62.074],
      description: "Lite White Fluorescent"
    },
    %{
      illuminant: "f7",
      cie1931: [95.044, 100.000, 108.755],
      cie1964: [95.792, 100.000, 107.687],
      description: "Daylight fluorescent, D65 simulator"
    },
    %{
      illuminant: "f8",
      cie1931: [96.413, 100.000, 82.333],
      cie1964: [97.115, 100.000, 81.135],
      description: "Sylvania F40, D50 simulator"
    },
    %{
      illuminant: "f9",
      cie1931: [100.365, 100.000, 67.868],
      cie1964: [102.116, 100.000, 67.826],
      description: "Cool White Fluorescent"
    },
    %{
      illuminant: "f10",
      cie1931: [96.174, 100.000, 81.712],
      cie1964: [99.001, 100.000, 83.134],
      description: "Ultralume 50, Philips TL85"
    },
    %{
      illuminant: "f11",
      cie1931: [100.966, 100.000, 64.370],
      cie1964: [103.866, 100.000, 65.627],
      description: "Ultralume 40, Philips TL84"
    },
    %{
      illuminant: "f12",
      cie1931: [108.046, 100.000, 39.228],
      cie1964: [111.428, 100.000, 40.353],
      description: "Ultralume 30, Philips TL83"
    }
  ]

  @doc """
  Returns the reference constants for an illuminant in a given mode

  ## Available modes
    - "cie1931": 2° (CIE 1931)
    - "cie1964": 10° (CIE 1964)

  ## Available illuminants

  #{Enum.map(@illuminant_references, &" - \"#{&1.illuminant}\": #{&1.description}") |> Enum.join("\n\n")}
  """
  def illuminant_reference(mode \\ "cie1931", illuminant \\ "d65")

  Enum.each(@illuminant_references, fn %{
                                         illuminant: illuminant,
                                         cie1931: cie1931,
                                         cie1964: cie1964
                                       } ->
    def illuminant_reference("cie1931", unquote(illuminant)), do: Nx.tensor(unquote(cie1931))
    def illuminant_reference("cie1964", unquote(illuminant)), do: Nx.tensor(unquote(cie1964))
  end)

  # defn illuminance("cie_1931", "d65"),
  # do: [95.047, 100.0, 108.883]

  def illuminant_reference(mode, illuminant),
    do: raise("unsupported illuminant #{illuminant} in #{mode}")
end
