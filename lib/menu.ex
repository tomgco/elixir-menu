defmodule Menu do
  def main() do
    main []
  end

  def main(args) do
    # Start collection procs
    Menu.LinesServer.start_link
    Menu.StateServer.start_link
    Menu.ItemsServer.start_link

    Charm.display :clear
    Menu.reset
    Charm.display :bright
    Charm.cursor false
    Charm.background :blue
    Charm.foreground :white

    Menu.write "Learn you the Elixir for much win. \n"
    Charm.display :faint
    Menu.write "Select an item \n"
    Menu.write String.ljust("", Menu.StateServer.get(:width), 9472) <> "\n"

    Menu.add "» HELLO WORLD"
    Menu.add "» BABY STEPS"
    Menu.add "» MY FIRST AGENT"
    Menu.add "» MY FIRST GEN-SERVER"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"
    Menu.add "» XXXXXXXXXXX"

    Menu.write String.ljust("", Menu.StateServer.get(:width), 9472) <> "\n"

    draw
    IO.write "\n"
  end

  def reset() do
    Charm.reset
  end

  def fillLine_multiple(n, y) when n < 1 do
    fillLine(y + n)
  end

  def fillLine_multiple(n, y) do
    fillLine(y + n)
    fillLine_multiple(n - 1, y)
  end

  def draw_row_multiple(i) when i < 1 do
    draw_row i
  end

  def draw_row_multiple(i) do
    draw_row i
    draw_row_multiple(i - 1)
  end

  def draw_row(i) do
    length = Menu.ItemsServer.length
    case length do
      length when length > 0 ->
        index = rem (i + length), length
        {label, x, y} = Menu.ItemsServer.at index
        Charm.position x, y
        Charm.background :blue
        Charm.foreground :white
        Charm.write String.ljust(label, max(0, Menu.StateServer.get(:width) - String.length(label)))
      _ ->
    end
  end

  defp draw() do
    fillLine_multiple(Menu.StateServer.get(:padding_top), Menu.StateServer.get(:y_init))
    draw_row_multiple Menu.ItemsServer.length
    Charm.background :blue
    Charm.foreground :white
    fillLine_multiple(Menu.StateServer.get(:padding_bottom), Menu.StateServer.get(:y))
  end

  defp fillLine(y) do
    if not Menu.LinesServer.exists?(y) do
      # check to see if this is got something in the tty
      Charm.position Menu.StateServer.get(:x_init), y
      Charm.write(String.ljust " ", Menu.StateServer.get :size)
      Menu.LinesServer.set y
    end
  end

  def add(label) do
    #index = Menu.ItemsServer.length
    {x, y} = { Menu.StateServer.get(:x), Menu.StateServer.get(:y) }
    Menu.ItemsServer.set(label, x, y)
    fillLine y
    Menu.StateServer.set(:y, y + 1)
  end

  def write(msg) do
    Charm.background :blue
    Charm.foreground :white
    fillLine Menu.StateServer.get :y

    Enum.map(String.split(msg, "\n"), fn s ->
      l = String.length s
      case l do
        l when l != 0 ->
          Charm.position Menu.StateServer.get(:x), Menu.StateServer.get(:y)
          Charm.write s
        _ ->
          Menu.StateServer.set(:x,
            Menu.StateServer.get(:x_init) + Menu.StateServer.get(:padding_left)
          )

          fillLine Menu.StateServer.get :y

          Menu.StateServer.set(:y,
            Menu.StateServer.get(:y) + 1
          )
      end
    end)

  end

end
