import Charm

defmodule Menu.LinesServer do
  def start_link do
    Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
  end

  @doc "Checks if the task has already executed"
  def exists?(number) do
    item = {number}
    Agent.get(__MODULE__, fn set ->
      item in set
    end)
  end

  @doc "Marks a task as executed"
  def set(number) do
    item = {number}
    Agent.update(__MODULE__, &Set.put(&1, number))
  end
end

defmodule Menu.StateServer do
  def start_link do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
  end

  @doc "Marks a task as executed"
  def set(key, value) do
    Agent.update(__MODULE__, &HashDict.put(&1, key, value))
  end

  @doc "Marks a task as executed"
  def get(key) do
    Agent.get(__MODULE__, &HashDict.get(&1, key))
  end
end


defmodule Menu do
  def main(args) do
    Menu.LinesServer.start_link
    Menu.StateServer.start_link
    Charm.display :bright
    Charm.foreground :white
    Charm.background :blue
    fillLine 1
    Charm.write "Learn you the Elixir for much win."
  end

  def reset() do
    Charm.reset
  end

  defp fillLine(y) do
    Charm.write y
    if not Menu.LinesServer.exists?(y) do
      # check to see if this is got something in the tty
      Charm.position Menu.StateServer.get(:x), y
      Charm.write(String.ljust "", 50)
      Menu.LinesServer.set y
    end
  end

  def write(msg) do
    Charm.background :blue
    Charm.foreground :white

    Enum.map(String.split(msg, "\n"), fn x ->
      Charm.position Menu.StateServer.get(:x), Menu.StateServer.get(:y)
    end)

  end

end
