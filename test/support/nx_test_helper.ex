defmodule NxColor.NxTestHelper do
  def assert_all_close(lhs, rhs, opts \\ [])

  def assert_all_close(lhs, rhs, opts) when is_tuple(lhs) and is_tuple(rhs) do
    lhs
    |> Tuple.to_list()
    |> Enum.zip_with(Tuple.to_list(rhs), &assert_all_close(&1, &2, opts))
  end

  def assert_all_close(lhs, rhs, opts) do
    res = Nx.all_close(lhs, rhs, opts) |> Nx.backend_transfer(Nx.BinaryBackend)

    unless Nx.to_number(res) == 1 do
      require IEx
      IEx.pry()

      raise """
      expected

      #{inspect(Nx.backend_transfer(lhs, Nx.BinaryBackend))}

      to be within tolerance of

      #{inspect(Nx.backend_transfer(rhs, Nx.BinaryBackend))}
      """
    end
  end

  def assert_equal(lhs, rhs) when is_tuple(lhs) and is_tuple(rhs) do
    lhs
    |> Tuple.to_list()
    |> Enum.zip_with(Tuple.to_list(rhs), &assert_equal/2)
  end

  def assert_equal(%Nx.Tensor{} = lhs, %Nx.Tensor{} = rhs) do
    res = Nx.equal(lhs, rhs) |> Nx.all() |> Nx.backend_transfer(Nx.BinaryBackend)

    unless Nx.to_number(res) == 1 do
      raise """
      expected

      #{inspect(Nx.backend_transfer(lhs, Nx.BinaryBackend))}

      to be equal to

      #{inspect(Nx.backend_transfer(rhs, Nx.BinaryBackend))}
      """
    end
  end

  def assert_equal(lhs, rhs) when is_map(lhs) and is_map(rhs) do
    lhs
    |> Map.values()
    |> Enum.zip_with(Map.values(rhs), &assert_equal/2)
  end

  def assert_not_equal(lhs, rhs) when is_tuple(lhs) and is_tuple(rhs) do
    lhs
    |> Tuple.to_list()
    |> Enum.zip_with(Tuple.to_list(rhs), &assert_not_equal/2)
  end

  def assert_not_equal(%Nx.Tensor{} = lhs, %Nx.Tensor{} = rhs) do
    res = Nx.equal(lhs, rhs) |> Nx.all() |> Nx.backend_transfer(Nx.BinaryBackend)

    unless Nx.to_number(res) == 0 do
      raise """
      expected

      #{inspect(Nx.backend_transfer(lhs, Nx.BinaryBackend))}

      to be not equal to

      #{inspect(Nx.backend_transfer(rhs, Nx.BinaryBackend))}
      """
    end
  end

  def assert_not_equal(lhs, rhs) when is_map(lhs) and is_map(rhs) do
    rhs
    |> Map.values()
    |> Enum.zip_with(Map.values(rhs), &assert_not_equal/2)
  end
end
