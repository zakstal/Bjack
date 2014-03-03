cards = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
suits = ['-:-','<>','->','<3']

@deck = []

@players = {}

@players_bet = {}

@players_win_loss = {}

@players_chest = {}

@highest_hand = 0

@odd_counter = 0

####################### Formatting ##########################

def double_space
	puts ""
		puts ""
end

####################### Game Setup ##########################

def how_many_decks(cards,suits)
	double_space
			puts "   how many decks would you like to play with?  "
				double_space
					quantity = gets.chomp.to_i
			quantity.times {creat_deck(cards,suits)}
end

def creat_deck(cards,suits)
	i = 0
		while i < 13
			suits.each {
		 		|suit|
		 			@deck << (cards[i] + suit)

			} 	

			i += 1
		end
	
end	

def new_card

	card = @deck.shuffle.shift	
		card
end

def add_players
	double_space
		puts " ----- what is the players name? -----".center(20)
			double_space
				player = gets.chomp.capitalize
					@players_bet[player] = 0
						@players[player] = []	
							@players_chest[player] = 0
						@players_win_loss[player] = []
					add_another(player)
end

def add_another(player)
	double_space
		puts "----- #{player} had been added -----"
			double_space
				puts"----- Add another player? y or n -----"
					double_space
						choice = gets.chomp

			if choice == 'y'
				add_players
			end

		@players["dealer"] = []
	@players_win_loss['dealer'] = []
end

def re_shuffle
	puts @deck.length
	puts plenght = @players.length * 2.5
	if @deck.length < plenght
		@deck.clear
			how_many_decks(cards,suits)
	end
end

############################## Betting Handler #########################

def bet
	@players_bet.each_key {
		|player|
			
				double_space
					bet_question(player)

							player_bet = gets.chomp

								if player_bet.to_i.is_a? Integer
								
									@players_bet[player]	=  player_bet.to_i
									
										double_space
											puts "          #{player} bet $#{player_bet}"
										double_space
								else
									double_space
										puts "             that is not a number"
									double_space
										bet
								end				
		
	}
end

def bet_question(player)
	puts "          #{player}, what is your bet?"
end


########################## Card Dealer #################################

def deal_cards


	2.times {
		@players.each_value {
			|value|
				card = @deck.shuffle.shift
					value << card
						@deck.delete(card)			
			}
		}

end

def show_cards
	players = @players.keys
		values = @players.values	
			i = 0
		while i < players.length
	     	puts""
				puts "#{players[i]}'s hand  #{values[i][0]} #{values[i][1]}"
					puts ""
			i += 1
		end

end





######################## Hit or Stay Handler #########################

def hit_stay
	@players.each_key {
		|player|
			player_hit_or_stay(player)			
	}

end

def players_choice(value,count,player)
	
	double_space
		puts "#{player}, Hit or Stay? h or s"
			double_space
				puts"  odds #{@odd_counter}                     bet $#{@players_bet[player]}   "
				

end



def player_hit_or_stay(player)
	value = @players[player]
		count =  card_counter(player)
			players_choice(value,count,player)
				hand = puts  "       #{value[0]} #{value[1]} #{value[2]} #{value[3]} #{value[4]} #{value[5]}   #{count} <- hand count  "
		
					if player == 'dealer'

						dealer_action(player,count)

					elsif @players[player] == "BUST!!     "
						choice = 's'
					else	
						choice = gets.chomp 
					end
						player_hit(choice,player,count,value,hand)
end

def dealer_action(player,count)

					if @players[player] == "BUST!!     " 
						choice = 's' 
					elsif  count >= 17
						choice = 's'		
					elsif count < @highest_hand 
						choice = 'h' 
					end	
end


def player_hit(choice,player,count,value,hand)
					if choice == 'h'	
						card = @deck.shuffle.shift
						@deck.delete(card)
					
						@players[player] = [value << card].flatten

							hand
								
						player_hit_or_stay(player)
					else
						@players_win_loss[player] = count
						hand
					end
end

############################# Hand counter ################################

def card_counter(player)
	start = @players[player].map {
		|card|
		card[0] 
		}
  count = 0
  	start.each {
  		|char|
  			if char == 'A'
  				count =	count + 11
  					@odd_counter = @odd_counter - 1
  			elsif char == 'J' 
  				count =	count + 10
  					@odd_counter = @odd_counter - 1
  			elsif char == 'Q' 
  				count =	count + 10
  					@odd_counter = @odd_counter - 1
  			elsif char == 'K' 
  				count =	count + 10
  					@odd_counter = @odd_counter - 1	
  			elsif char.to_i == 1 
  				count = count + 10
  					@odd_counter = @odd_counter - 1
  			elsif char.to_i < 7
  				@odd_counter = @odd_counter + 1
  				count =	count + char.to_i
  			else
  				count =	count + char.to_i
  			end
  }	
  	highest_hand(count)
 		bust(count, player)
end


################################ Scoring ############################

def bust (count, player)
	if count > 21
		@players[player].clear
			@players[player] = "BUST!!     "
	else
		count
	end

end

def highest_hand(count)
	@highest_hand = count if count > @highest_hand && count < 21
	 
end	

def winners_looseres
	dealer = @players_win_loss['dealer']

	 @players_win_loss.each_key {
	 	|player|
	 	
		 
	 		score = @players_win_loss[player]
	 			chest = @players_chest[player]
	 			 	player_bet = @players_bet[player].to_i
	 					

	 					if player == 'dealer'

	 					elsif score == "BUST!!     "
	 						loose = @players_chest[player] = chest + (player_bet * -1)
	 							loose
	 					elsif dealer == "BUST!!     "
	 						win = @players_chest[player] = chest + player_bet 
	 							win
	 					elsif score > dealer
	 						win = @players_chest[player] = chest + player_bet
	 						win
	 					elsif dealer > score
	 						loose = @players_chest[player] = chest + (player_bet * -1)
	 						loose
	 					end


	 }
	 wrap_up
end

###################### Game End ################################

def wrap_up
	players = ''
		money = ''
			@players_chest.each {
				|player, chest|
					players << "    #{player}     " 
						money << "    #{chest}     "
	}

	double_space
		puts players
			double_space
				puts money
end

def play_again

	double_space
		puts "Play another hand? y or n"
			double_space
				choice = gets.chomp
			if choice == 'y'

				@players.each_key {
					|player|
						@players[player] = []
				}
				
				play
			elsif choice == 'n'

			else
				double_space
					puts "thats not an answer"
						 play_again
			end

end

###################### Game Handler #########################

def game_setup(cards,suits)
	how_many_decks(cards,suits)	
	add_players
end

def play
	re_shuffle
	bet
	deal_cards
	show_cards
	hit_stay
	winners_looseres
	play_again
end



game_setup(cards,suits)
play



