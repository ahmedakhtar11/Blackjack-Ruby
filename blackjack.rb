# Class to Create a Card Object with "suit", "name" and "value" attributes.
class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end
end

# Class to Create a Deck of Cards Object with 52 Card Instances
class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}
  
  # Shuffling the Deck upon Creation of the Object
  def initialize
    shuffle
  end

  # Method to Deal a Random Card from the Deck of Cards
  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  # Method to Shuffle the Deck of Cards
  def shuffle
    @playable_cards = []
    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

# Class to Create a Hand Object with an Array of Cards for a Game.
class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

end

#Solution::::::::::::::::

# Class to Create a Blackjack Game Object with all of the methods needed to run the game.

class Blackjack

  attr_accessor :deckofcards, :dealer, :player, :players_score, :dealers_score, :dealers_softhand, :players_softhand, :player_stands

  def initialize
    # Adding an object of the Deck Class (New Deck of Cards) to the "deckofcards" variable.
    @deckofcards = Deck.new
    # Adding an object of the Hand Class ((Array of Cards) to the "dealer" variable.
    @dealer= Hand.new
    # Adding an object of the Hand Class (Array of Cards) to the "player" variable.
    @player = Hand.new
    # Variable to hold the score of the Dealer's Soft Hand. (Ace counting as 1 instead of 11)
    @dealers_softhand = 0
    # Variable to hold the score of the Player's Soft Hand. (Ace counting as 1 instead of 11)
    @players_softhand = 0
    # Boolean to Determine whether the Player has chosen to Stand yet.
    @player_stands = false

    # Method to begin the round.
    begin_round
    # Initializing the scores_table method!
    scores_table
  end

  # Method to begin a round.
  def begin_round
    # Note* (Hand Class Method called "cards") and (Deck Class Method called "deal_card")
    # Adding a random card to Player's Hand
    @player.cards << @deckofcards.deal_card
    # Adding a second random card to Player's Hand
    @player.cards << @deckofcards.deal_card    
    # Adding a random card to Dealer's Hand
    @dealer.cards << @deckofcards.deal_card
    # Adding a second random card to Player's Hand
    @dealer.cards << @deckofcards.deal_card
    # Calling the scores_update method at the start of a round.
    scores_update
  end

  # Method to display the Scores as a Table.
  def scores_table
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts " Scores: "
    puts " -Dealer Score: #{@dealers_score}"
    puts " -Player Score: #{@players_score}"
    puts
    puts "  Dealer's Cards: "
    if player_stands == false
      puts "  (***************)"
      puts "  (#{@dealer.cards[1].name.upcase} OF #{@dealer.cards[1].suit.upcase})"
    else
      for card in @dealer.cards
        puts "  (#{card.name.upcase} OF #{card.suit.upcase})"
      end
    end
    puts
    puts "  Player's Cards: "
    # For Loop to Display all of the Player's Cards
    for card in @player.cards
      puts "  (#{card.name.upcase} OF #{card.suit.upcase})"
    end
    puts
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     
  end
    # Method to Update Scores:
  def scores_update
    # Variable to Hold the Player's Score:
    @players_score = 0
    # Variable to Hold the Dealer's Score:
    @dealers_score = 0

    # Player - Different Scenarios for an Ace
    #########################################
    for card in @player.cards
      if card.name == :ace
        # If player's card is an Ace, then increase the player's softhand score by 1.
        @players_softhand += 1
        # If player's card is an Ace and the player's score is greater than 11, then increase the score by 1
        if @players_score >= 11
          @players_score += 1

          #Note* Alternatively:
          #@players_score += card.value.last
        else
          # Else increase the score by 11
          @players_score += 11
          #Note* Alternatively:
          #@players_score += card.value.first
        end
      else
        # Else if card isn't an Ace, then increase the value of the score by the cards value.
        @players_score += card.value
      end
    end

      # Dealer - Scenario for an Ace
      ##############################

      # If player hasn't chosen to stand
      if player_stands == false
        # and If the dealers first card is an Ace
        if @dealer.cards[1].name == :ace
          # then increase the dealer's soft hand score by 1
          @dealers_softhand += 1
          # and increase the dealer's score by 11
          @dealers_score += 11
        else
          # else increase the dealer's score by the value of the card.
          @dealers_score += @dealer.cards[1].value
        end

      # Else if Player has chosen to stand,  
      else
        # For each of the Dealer's cards
        for card in @dealer.cards
          # If any card is an ace,
          if card.name == :ace
            # Then increase the dealer's softhand score by 1
            @dealers_softhand += 1
            # If player has chosen to stand and if the card is an ace and if the dealer's score is greater than 10,
            if @dealers_score >= 11
              # then increase the dealer's score by one
              @dealers_score += 1
            else
              # else increase the dealer's score by 11.
              @dealers_score += 11
            end
          # Else if the dealer's card is not an Ace, then increase the score by the cards value.  
          else
            @dealers_score += card.value
          end
        end
      end

      # Dealing with Edge Cases for an Ace Card
      # First 2 Cards are both Aces or one of the first 2 cards is an Ace, but then a resulting value makes the score go over 21
      ######################################

      # If player score is greater than 21 and player's softhand is greater than 0, 
      if @players_score > 21 && players_softhand > 0
        # then subtract the score by 10 (Difference in value of an Ace.)
        @players_score -= 10
        # and subtract the score of the softhand score by 1.
        @players_softhand -= 1
      end

      # If dealer score is greater than 21 and dealer's softhand score is greater than 0, 
      if @dealers_score > 21 && dealers_softhand > 0
          # then subtract the dealer's score by 10 (Difference in value of an Ace.)
          @dealers_score -= 10
          # then subtract the dealer's soft hand score by 1.
          @dealers_softhand -= 1
      end
    end

    # Method to run the scores_update Method and the scores_table Method on Dealer's turn.
    def dealers_move
      scores_update
      scores_table

      while @dealers_score < 21
        # Dealer Stands if his score is 17 or higher.
        if @dealers_score >= 17
          break
        end

        # Dealer Draws a Card from the Deck.
        @dealer.cards << @deckofcards.deal_card
        scores_update
        scores_table
    end
  end
end


# Class to Create a Rules Object dealing with different scenarios of the game.

class Rules
  while true
    puts "*************************************************************************"
    puts "-------------------------------------------------------------------------"
    puts "Starting a New Game of Ruby BlackJack. Enter 'h' to hit and 's' to stand."
    puts "-------------------------------------------------------------------------"
    puts "*************************************************************************"

    # Creating a Blackjack Game Object for a Game of Blackjack.
    blackjack = Blackjack.new

    # Prompt the player to Hit or Stand if he hasn't busted.
    while blackjack.players_score < 21
      puts "HIT OR STAND? (h/s)"
      decision = gets.chomp

      # Start the dealer's turn if the player chooses to Stand.
      if decision == "s"
        blackjack.player_stands = true
        blackjack.dealers_move
        break
      
      # Player Draws a Card from the Deck if he chooses to Hit.
      elsif decision == "h"
        blackjack.player.cards << blackjack.deckofcards.deal_card
        blackjack.scores_update
        blackjack.scores_table
      
      # Else Error Message.
      else
        puts "Error. Incorrect Input."
      end
    end

    puts

    # Scenario 1: Player Wins: Player gets a Blackjack.
    if blackjack.players_score == 21 && blackjack.player.cards.size == 2
      puts "~ Player Wins! Blackjack! ~"
    
    # Scenario 2: Player Wins: Player gets 21.
    elsif blackjack.players_score == 21
      puts "~ Player Wins! You Scored 21!! ~"

    # Scenario 3: Dealer Wins: Player draws over 21 and Busts.
    elsif blackjack.players_score > 21
      puts "~ You Busted! Dealer Wins! ~"

    # Scenario 4: Player Wins: Player Score is greater than Dealer's Score.
    elsif blackjack.players_score > blackjack.dealers_score
      puts "~ Player Wins! You have a Higher Score Than the Dealer!~"

    # Scenario 5: Player Wins: Dealer Draws over 21 and Busts.
    elsif blackjack.dealers_score > 21
      puts "~ Player Wins! Dealer Busted. ~"

    # Scenario 6: Dealer Wins: Dealer scores 21.
    elsif blackjack.dealers_score == 21 && blackjack.players_score < 21
      puts "~ Dealer Wins! ~"

    # Scenario 7: Dealer Wins: Dealer's Score is greater than Player's Score.
    elsif blackjack.players_score < blackjack.dealers_score
      puts "~ Dealer Wins! ~"
    
    else
      puts "~ Push! Tie Game! ~"
    end

    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

    # Running the Next Game of Blackjack.
    while true
      puts "Play Another Game of Ruby BlackJack? (y/n)"
      decision = gets.chomp
      if decision == "y"
        break
      elsif decision == "n"
        exit(0)

      # Error Message.
      else
        puts "Error. Incorrect Input."
        next
      end
    end

  end
end

blackjack = Rules.new

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suit_is_correct
    assert_equal @card.suit, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end