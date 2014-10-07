defmodule Menu.StateServer do
  def start_link do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
    
    x_init = 3
    y_init = 2
    width = 65 
    Menu.StateServer.set :x_init, x_init
    Menu.StateServer.set :y_init, y_init
    Menu.StateServer.set :x, x_init + 2
    Menu.StateServer.set :y, y_init + 2
    Menu.StateServer.set :padding_left, 2
    Menu.StateServer.set :padding_right, 2
    Menu.StateServer.set :padding_top, 1
    Menu.StateServer.set :padding_bottom, 1
    Menu.StateServer.set :width, width
    Menu.StateServer.set :size, width + 2 + 2 # width + padding left + padding right
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

