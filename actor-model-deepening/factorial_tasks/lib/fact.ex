defmodule FactTasks do
  defp fact_rec(n, acc\\1)
  defp fact_rec(n, acc) when n <= 1, do: acc
  defp fact_rec(n, acc) do
    fact_rec(n-1, acc*n)
  end

  def fact(n) do
    fact_rec(n)
  end


  defmodule CLI do
    def main(args \\ []) do
      file = File.stream!(args)

      tasks = file
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Stream.map(fn (n) -> Task.async(fn () -> {n, FactTasks.fact(n)} end) end)
      |> Enum.to_list()

      res = Task.await_many(tasks, :infinity)

      res
      |> Enum.each(fn {n, value} -> IO.puts("The factorial of #{n} is #{value}") end)
    end
  end
end
