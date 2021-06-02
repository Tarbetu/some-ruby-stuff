# frozen_string_literal: false

require 'pry'

class Node
  include Comparable
  attr_reader :value
  attr_accessor :left, :right

  def <=>(other)
    return @value <=> other.value if other.instance_of? Node

    @value <=> other
  end

  def initialize(data, left = nil, right = nil)
    @value = data
    @left = left
    @right = right
  end

  def to_s
    "Node: #{value}
    <-: #{left.inspect}
    ->: #{right.inspect}"
  end
end

class Tree
  def initialize(arr)
    @root = build_tree(arr)
  end

  def find(value, node = @root)
    return nil  if node.nil?
    return node if node.value == value

    value < node.value ? find(value, node.left) : find(value, node.right)
  end

  def insert!(value)
    return nil if find(value)

    append(value)
  end

  def delete!(value)
    return nil unless find(value)
    raise "Nope. I won't delete the root node." if value == @root.value

    exterminate(value)
  end

  # It looks depth and height doing almost same thing
  # I don't totally understand what is depth and height

  def depth
    queue = [] << @root
    iter = 0
    until queue.empty?
      iter += 1
      node = queue.shift
      queue.pop
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
    end

    iter
  end

  def height(root = @root)
    return 0 if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)

    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height) == 0 | -1 | 1
    return true if balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    level_order.sort.build_tree
  end

  # Stolen from The Odin Project :)
  def inspect(node = @root, prefix = '', is_left = true)
    inspect(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    inspect(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order
    queue = []
    array_to_the_return = []

    queue << @root
    until queue.empty?
      current = queue.shift
      array_to_the_return << current.value
      queue.push(current.left) unless current.left.nil?
      queue.push(current.right) unless current.right.nil?
    end

    array_to_the_return
  end

  def inorder(root = @root, array_to_the_return = [])
    return array_to_the_return unless root

    inorder(root.left, array_to_the_return)
    array_to_the_return << root.value
    inorder(root.right, array_to_the_return)
  end

  def preorder(root = @root, array_to_the_return = [])
    return array_to_the_return unless root

    array_to_the_return << root.value
    preorder(root.left, array_to_the_return)
    preorder(root.right, array_to_the_return)
  end

  def postorder(root = @root, array_to_the_return = [])
    return array_to_the_return unless root

    postorder(root.left, array_to_the_return)
    postorder(root.right, array_to_the_return)
    array_to_the_return << root.value
  end

  private

  def exterminate(value, node = @root)
    if node.left.value == value
      node.left = nil
      return nil
    elsif node.right.value == value
      node.right = nil
      return nil
    end

    value < @root.value ? exterminate(value, node.left) : exterminate(value, node.right)
  end

  def append(value, node = @root)
    if node.left.nil? && node.right.nil?
      if value > node.value
        node.right = Node.new(value)
      else
        node.left = Node.new(value)
      end
      return nil
    end

    value < @root.value ? append(value, node.left) : append(value, node.right)
  end

  def build_tree(arr)
    arr = arr.sort.uniq
    build_recursively(arr)
  end

  def build_recursively(arr)
    return nil if arr.empty?

    mid = (arr.size / 2)
    Node.new(
      arr.fetch(mid),
      build_recursively(arr[0, mid]),
      build_recursively(arr[mid + 1, arr.size - 1])
    )
  end
end

# arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
bst = Tree.new(arr)
p bst
p bst.height
p bst.depth
p bst.balanced?
