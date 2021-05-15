def substrings(string, dictionary) 
  count = Hash.new 0
  string = string.downcase
  matched_words = dictionary.select { |word| string.include? word } 
  matched_words.each do |matched_word|
    counts = string.split.reduce(0) do |total, wordy|  
      wordy.include?(matched_word) ? total += 1 : total = total
    end
    count[matched_word] += counts
  end
  count
end

dictionary = ["below","down","go","going","horn","how","howdy",
              "it","i","low","own","part","partner","sit"]

pp substrings("below",dictionary)

pp substrings("Howdy partner, sit down! How's it going?", dictionary)
