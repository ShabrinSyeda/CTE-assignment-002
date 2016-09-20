class Array
  def sort_arr
    n = self.length
    array = self.clone
    loop do
      swapped = false
      (n-1).times do |i|
        if array[i] > array[i+1]
          array[i], array[i+1] = array[i+1], array[i]
          swapped = true
        end
      end
      break if not swapped
    end
    array
  end
  
  def my_map
    return to_enum :my_map unless block_given?
    result = self.collect { |element|  yield(element) }
  end
end


# To execute the code follow the below steps
arr = [3,2,4,1]
arr.sort_arr
arr
arr.my_map do |ele|
  ele + 2
end
arr.my_map(&:to_s)
