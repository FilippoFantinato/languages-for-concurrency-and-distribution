defmodule Philosopher do
  defstruct [:name, :left_fork, :right_fork]

  def start_link(opts) do
    phil = %Philosopher{name: opts.name, left_fork: opts.left_fork, right_fork: opts.right_fork}

    {:ok, spawn_link(fn () -> loop(phil) end)}
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
            eat(phil.name, first_fork, second_fork)
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

  defp eat(name, fork1, fork2) do
    t = :rand.uniform(1000)

    prob_to_suffocate = :rand.uniform(10)

    if prob_to_suffocate == 1 do
      IO.puts("#{name} is SUFFOCATED!")
      leave_fork(fork1)
      leave_fork(fork2)
      exit(:suffocated)
    end

    IO.puts("#{name} is EATING for #{t} milliseconds")
    :timer.sleep(t)
  end

  def child_spec(opts) do
    %{
      id: opts.name,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end
end
