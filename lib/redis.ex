defmodule Gate.Storages.Redis do
  def start_link do
    redis_conf = Application.get_env(:gate, :redis)
    {:ok, pid} = Exredis.start_link(redis_conf[:host], String.to_integer(redis_conf[:port]))
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def get do
    all_keys |> Enum.reduce %{}, fn key, acc ->
      Dict.put(acc, key, hash_data(key) |> to_map)
    end
  end

  defp all_keys do
    Exredis.query(Process.whereis(__MODULE__), ["KEYS", "*"])
  end

  defp hash_data(key) do
    Exredis.query(Process.whereis(__MODULE__), ["HGETALL", key])
  end

  defp to_map(list) do
    list |> Enum.chunk(2) |> Enum.into(%{}, fn x -> List.to_tuple(x) end)
  end

  def get(key, field) do
    case Exredis.query Process.whereis(__MODULE__), ["HGET", key, field] do
      :undefined -> nil
      value -> value
    end
  end

  def exists?(key) do
    case Exredis.query Process.whereis(__MODULE__), ["EXISTS", key] do
      "1" -> true
      "0" -> false
    end
  end

  def set(key, field, value) do
    Exredis.query Process.whereis(__MODULE__), ["HSET", key, field, value]
  end

  def delete(key) do
    Exredis.query Process.whereis(__MODULE__), ["DEL", key]
  end

  def clean! do
    Exredis.query Process.whereis(__MODULE__), ["FLUSHDB"]
  end
end