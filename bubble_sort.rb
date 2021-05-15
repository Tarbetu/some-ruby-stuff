def bubble_sort(arr)
  loop do
    new_arr = arr.clone
    i = 0
    while i < arr.size - 1 
      first_element = arr[i]
      second_element = arr[i+1]
      if first_element > second_element 
        arr[i] = second_element
        arr[i+1] = first_element 
      end
      i += 1
    end
  break if arr == new_arr
  end
  arr
end
