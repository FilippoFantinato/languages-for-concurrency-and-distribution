defmodule DiningPhilosophers do
  def main(_args\\[]) do
    fork1 = Fork.init()
    fork2 = Fork.init()
    fork3 = Fork.init()
    fork4 = Fork.init()
    fork5 = Fork.init()

    phil1 = Philosopher.init("Aristotele", fork1, fork2)
    phil2 = Philosopher.init("Bacon", fork2, fork3)
    phil3 = Philosopher.init("Cartesio", fork3, fork4)
    phil4 = Philosopher.init("Diogene", fork4, fork5)
    phil5 = Philosopher.init("Eliot", fork5, fork1)

    :timer.sleep(:infinity)
  end
end
