# frozen_string_literal: false

require 'pry'

class LinkedList
  def initialize
    @start_node = Node.create_head(Node.new)
  end

  def append(value, mem = :null)
    mem = @start_node if mem == :null
    next_node = mem.next_node

    if mem.next_node.end?
      mem.next_node.index += 1
      mem.next_node = Node.new(value, next_node, next_node.index - 1)
      return nil
    end

    append(value, next_node)
  end

  def prepend(value)
    node_to_be_placed = Node.new(value, @start_node.next_node, 0)
    mem = @start_node

    until mem.next_node.nil?
      mem.next_node.index += 1
      mem = mem.next_node
    end

    @start_node.next_node = node_to_be_placed
    nil
  end

  def size
    count = 0
    mem = @start_node

    until mem.end?
      mem = mem.next_node
      count += 1
    end

    count
  end

  def head
    at(0)
  end

  def tail
    tail = @start_node
    tail = tail.next_node until tail.next_node.end?

    tail
  end

  def at(index, mem = nil)
    mem = @start_node if mem.nil?
    return mem if mem.index == index

    if mem.end?
      nil
    else
      mem = mem.next_node
      at(index, mem)
    end
  end

  def pop
    new_tail = at(tail.index - 1)
    new_tail.next_node = tail.next_node
  end

  def contains?(value)
    mem = @start_node
    until mem.end?
      return true if mem.next_node.value == value

      mem = mem.next_node
    end

    false
  end

  def find(value)
    mem = @start_node
    until mem.end?
      return mem.next_node.index if mem.next_node.value == value

      mem = mem.next_node
    end

    nil
  end

  def inspect
    string = ''
    mem = @start_node.next_node

    until mem.end?
      string << "#{mem} -> "
      mem = mem.next_node
    end

    string << '(nil)'

    string
  end

  def insert_at(value, index)
    raise "You can't insert after the end node!" if index >= size

    node_going_to_be_shifted = at(index)

    until node_going_to_be_shifted.end?
      node_going_to_be_shifted = node_going_to_be_shifted.next_node
      node_going_to_be_shifted.index += 1
    end

    before_the_shifting_node = at(index - 1)
    before_the_shifting_node.next_node = Node.new(value, node_going_to_be_shifted, index)
  end

  def remove_at(index)
    raise "You can't delete the end node!" if at(index).end?

    node_before_removed_node = at(index - 1)
    node_before_removed_node.next_node = at(index).next_node

    mem = node_before_removed_node.next_node

    until mem.nil?
      mem.index -= 1
      mem = mem.next_node
    end
  end
end

class Node
  attr_accessor :value, :next_node, :index

  def initialize(value = :nothing_else, next_node = nil, index = -1)
    @value = value
    @next_node = next_node
    @index = index
  end

  def inspect
    "(#{@value})"
  end

  def end?
    value == :nothing_else
  end

  def self.create_head(next_node)
    next_node.index = 0
    Node.new :BestHeadEver, next_node
  end
end

# For testing - I know it looks odd :)
linked = LinkedList.new
linked.append :rörörö
linked.append 'yaşa fenerbahçe'
linked.append 666
binding.pry
p linked
