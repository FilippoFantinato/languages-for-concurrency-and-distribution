defmodule Fork do
  def init() do
    spawn(fn () -> loop(false) end)
  end

  defp loop(occupied) do
    receive do
      {:request, pid} ->
        if occupied do
          send(pid, :occupied)
        else
          send(pid, :taken)
        end
        loop(true)
      :leave ->
        loop(false)
    end
  end
end
