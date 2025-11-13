defmodule Helper do
  def save({:ok, data}, filename) do
    path = "priv/example/#{filename}.txt"
    string = inspect(data)

    File.write!(path, string)
  end

  def save(result, _) do
    result
  end
end
