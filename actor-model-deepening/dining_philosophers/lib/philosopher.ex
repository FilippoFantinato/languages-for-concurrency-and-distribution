defmodule Philosopher do
  defstruct [:name, :left_fork, :right_fork]

  def init(name, left_fork, right_fork) do
    phil = %Philosopher{name: name, left_fork: left_fork, right_fork: right_fork}
    spawn(fn () ->
      loop(phil)
    end)
  end

  defp loop(phil) do
    think(phil.name)

    first_right? = :rand.uniform(2) == 1
    {first_fork, second_fork} = case first_right? do
      true  -> {phil.right_fork, phil.left_fork}
      false -> {phil.left_fork, phil.right_fork}
    end

    case take_fork(first_fork) do
      :taken ->
        case take_fork(second_fork) do
          :taken ->
            eat(phil.name)
            leave_fork(second_fork)
            leave_fork(first_fork)
          :occupied ->
            leave_fork(first_fork)
        end
      :occupied ->
        :ok
    end

    loop(phil)
  end

  defp take_fork(fork) do
    send(fork, {:request, self()})
    receive do
      :occupied -> :occupied
      :taken -> :taken
      _ -> raise("Something else happens")
    end
  end

  defp leave_fork(fork) do
    send(fork, :leave)
  end

  defp think(name) do
    t = :rand.uniform(1000)
    IO.puts("#{name} is THINKING for #{t} milliseconds")
    :timer.sleep(t)
  end

  defp eat(name) do
    t = :rand.uniform(1000)
    IO.puts("#{name} is EATING for #{t} milliseconds")
    :timer.sleep(t)
  end
end
