# frozen_string_literal: true

require 'pry'

# Fibonacci

# By iteration
def fibs(final_step)
  fib_array = [0, 1]
  step = 0
  until step == final_step - 1
    fib_array << fib_array[step] + fib_array[step + 1]
    step += 1
  end

  fib_array
end

# By recursion
def fibs_by_recursion(final_step, step = 0, fib_array = [0,1])
  return fib_array if step == final_step - 1

  fib_array << fib_array[step] + fib_array[step + 1]
  step += 1
  fibs_by_recursion(final_step, step, fib_array)
end

# For testing
class FibonacciAssertion
  class AssertionError < StandardError
    def message
      'Assertion Error!'
    end
  end

  def initialize(fib_arr, expection)
    @arr = fib_arr
    @expection = expection
  end

  def testing
    raise AssertionError unless @arr.last == @expection

    puts 'Assertion Successful!'
  end
end

# FibonacciAssertion.new(fibs(100), 354224848179261915075).testing
# FibonacciAssertion.new(fibs(100), fibs_by_recursion(100).last).testing

# Merge Sort
def merge_sort(arr)
  mid = arr.size / 2
  if arr.size > 1
    left = arr[0..mid - 1]
    right = arr[mid..arr.size]
    return merging merge_sort(left), merge_sort(right)
  end
  arr
end

def merging(left, right)
  merged = []
  iter   = left.size + right.size

  iter.times do
    if left[0] && right[0]
      left[0] < right[0] ? merged << left.shift : merged << right.shift
    end
  end

  merged + left + right
end

# For testing
class SortingAssertion < FibonacciAssertion
  def initialize(arr)
    @arr = arr
  end

  def testing
    raise AssertionError unless merge_sort(@arr) == @arr.sort

    puts 'Sorting Successful!'
  end
end

# SortingAssertion.new([2, 5, 1, 4, 3]).testing
# SortingAssertion.new((0..99928).to_a.shuffle).testing
