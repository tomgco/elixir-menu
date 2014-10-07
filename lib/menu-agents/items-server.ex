defmodule Menu.ItemsServer do
  def start_link do
    Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
  end

  def exists?(label, x, y) do
    item = {label, x, y}
    Agent.get(__MODULE__, fn set ->
      item in set
    end)
  end

  def set(label, x, y) do
    item = {label, x, y}
    Agent.update(__MODULE__, &Set.put(&1, item))
  end

  def at(index) do
    Agent.get(__MODULE__, fn set ->
      Enum.at(set, index)
    end)
  end 

  def length() do
    Agent.get(__MODULE__, fn set ->
      Enum.count(set, fn n -> n end)
    end)
  end
end

