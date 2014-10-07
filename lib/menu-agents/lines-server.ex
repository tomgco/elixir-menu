defmodule Menu.LinesServer do
  def start_link do
    Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
  end

  @doc "Checks if the task has already executed"
  def exists?(key) do
    item = {key, true}
    Agent.get(__MODULE__, fn set ->
      item in set
    end)
  end

  @doc "Marks a task as executed"
  def set(key) do
    item = {key, true}
    Agent.update(__MODULE__, &Set.put(&1, item))
  end
end

