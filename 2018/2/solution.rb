def solution(input)
  twofers   = 0
  threefers = 0

  input.each do |line|
    letter_counts_hash = get_letter_counts(line)

    twofers   += 1 unless letter_counts_hash[2].empty?
    threefers += 1 unless letter_counts_hash[3].empty?
  end
  twofers * threefers
end

def get_letter_counts(line)
  hash    = Hash.new { |hash, key| hash[key] = [] }
  hash[0] = ('a'..'z').to_a

  line.each_char do |char|
    hash.keys.each do |key|
      if hash[key].include?(char)
        hash[key].delete(char)
        hash[key + 1] << char
        break
      end
    end
  end
  hash
end

file = File.readlines('./input.txt')
p solution(file)
