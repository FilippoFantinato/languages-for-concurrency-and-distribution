defmodule DiningPhilosophersDeathSafety do

  def main(_args\\[]) do
    fork1 = Fork.init()
    fork2 = Fork.init()
    fork3 = Fork.init()
    fork4 = Fork.init()
    fork5 = Fork.init()

    philosophers = [
      {Philosopher, %{name: "Aristotele", left_fork: fork1, right_fork: fork2}},
      {Philosopher, %{name: "Bacon", left_fork: fork2, right_fork: fork3}},
      {Philosopher, %{name: "Cartesio", left_fork: fork3, right_fork: fork4}},
      {Philosopher, %{name: "Diogene", left_fork: fork4, right_fork: fork5}},
      {Philosopher, %{name: "Ernesto", left_fork: fork5, right_fork: fork1}}
    ]

    Fate.start_link(philosophers)

    :timer.sleep(:timer.minutes(3))
  end
end
