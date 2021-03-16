# frozen_string_literal: true

require 'yaml'

def read_file(file_name)
  array = File.readlines(file_name)
end

def select_word(length_from, length_to, array)
  loop do
    word = array.sample.chomp.downcase
    return word if word.length >= length_from && word.length < length_to
  end
end

def user_input
  loop do
    input = gets.chomp
    return input if ('a'..'z').include?(input) || ('A'..'Z').include?(input) || input == 'exit'
  end
end

def word_contain_letter?(word, letter)
  return false if word.nil?

  word.include?(letter.downcase)
end

def word_complete?(word, array_solution)
  word.split('') == array_solution
end

def add_used_letter(array_used_letters, letter)
  array_used_letters.insert(-1, letter.downcase) unless word_contain_letter?(array_used_letters, letter)
end

def set_letter(word_help, array, letter)
  array_word = word_help.split('')

  word_help.count(letter).times do
    index = array_word.index(letter)
    array[index] = letter
    word_help[index] = ' '
    array_word = word_help.split('')
  end
  array
end

def save_game(hash_for_life)
  text = YAML.dump(hash_for_life)
  File.open('save.txt', 'w') { |file| file.write(text) }
end

def load_game(hash_for_life)
  text = YAML.load_file('save.txt')
  hash_for_life = text
end

def menu()
  finished = false

  array = read_file('dictionary.txt')

  word = select_word(5, 12, array)
  hash_for_life = {
    word: word,
    word_help: String.new(word),
    array_solution: [],
    array_used_letters: [],
    game_count: 0,
    guess_count: 7
  }

  hash_for_life[:word].length.times { hash_for_life[:array_solution].insert(-1, '_') }

  loop do
    if finished
      word = select_word(5, 12, array)
      hash_for_life = {
        word: word,
        word_help: String.new(word),
        array_solution: [],
        array_used_letters: [],
        game_count: 0,
        guess_count: 7
      }

      hash_for_life[:word].length.times { hash_for_life[:array_solution].insert(-1, '_') }
      finished = false
    end

    puts '1 Play the game'
    puts '2 Save game'
    puts '3 Load game'
    puts '4 exit'
    print 'Your choice: '
    choice = gets.chomp

    system('clear')
    if choice == '1'
      finished = game(hash_for_life)
    elsif choice == '2'
      save_game(hash_for_life)
      puts 'game saved successfully'
    elsif choice == '3'
      hash_for_life = load_game(hash_for_life)
      puts 'game loaded successfully'
    elsif choice == '4'
      break
    else
      puts 'wrong number'
      puts
    end
  end
end

def game(hash_for_life)
  loop do
    break if hash_for_life[:game_count] >= hash_for_life[:guess_count]

    puts 'if you wish to exit instead of a letter write exit'
    puts "You have #{hash_for_life[:guess_count] - hash_for_life[:game_count]} tries left"
    hash_for_life[:array_solution].each { |item| print item }
    puts "\n\nLetters that were used already: #{hash_for_life[:array_used_letters]}"

    active_letter = user_input
    if active_letter == 'exit'
      system('clear')
      return false 
    end

    system('clear')
    if word_contain_letter?(hash_for_life[:array_used_letters], active_letter)
      puts "The letter #{active_letter} was already used"
      hash_for_life[:game_count] += 1
      next
    end

    hash_for_life[:array_used_letters] = add_used_letter(hash_for_life[:array_used_letters], active_letter)

    break if word_complete?(hash_for_life[:word], hash_for_life[:array_solution])

    if word_contain_letter?(hash_for_life[:word], active_letter)
      puts "The word contains the letter #{active_letter}"
      set_letter(hash_for_life[:word_help], hash_for_life[:array_solution], active_letter)
    else
      puts "The word doesn\'t contain the letter #{active_letter}"
      hash_for_life[:game_count] += 1
    end
    break if word_complete?(hash_for_life[:word], hash_for_life[:array_solution])
  end
  system('clear')
  if hash_for_life[:game_count] < 7
    puts "\nCongratulations you won! \nThe word was #{hash_for_life[:word]}"
  else
    puts "\nYou failed! \nThe word was #{hash_for_life[:word]}"
  end
  true
end

system('clear')
menu
