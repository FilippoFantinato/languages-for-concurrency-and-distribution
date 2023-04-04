defmodule FactNaive do
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
      {:ok, fd} = File.open(args, [:read])

      Process.register(self(), :main)

      spawn(fn () -> read_file(fd) end)
      listener()
    end

    def listener() do
      receive do
        {:ok, n, value} ->
          IO.puts("The factorial of #{n} is #{value}")
          listener()
        # :end -> :ok
        _ -> listener()
      end
    end

    @spec read_file(atom | pid) :: any
    def read_file(fd) do
      case IO.read(fd, :line) do
        # :eof -> send(:main, :end)
        :eof -> :ok
        {:error, reason} -> IO.puts("Error: #{reason}")
        data ->
          case Integer.parse(data) do
            {n, _} ->
              IO.puts("Computing factorial of #{n}")
              spawn(fn () -> send(:main, {:ok, n, FactNaive.fact(n)}) end)
            :error -> IO.puts "#{data} is not a number"
          end
          read_file(fd)
      end

    end
  end
end
