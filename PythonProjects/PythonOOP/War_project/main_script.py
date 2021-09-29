from card_classes import *

# GAME SETUP

# define players
player_one = Player("Obi")
player_two = Player("Oli")

# shuffle and split deck
deck = Deck()
deck.shuffle()

for cards in range(26):
    player_one.add_cards(deck.deal_one())
    player_two.add_cards(deck.deal_one())

game_on = True #for while loop
round_number = 0 #To keep track of rounds

# GAMEPLAY

print("Welcome to War")

while game_on:

    round_number += 1
    print(f"Round {round_number}")

    # checks if players are still eligible to play
    # that is, they don't have 0 cards
    if len(player_one.all_cards) == 0:
        print(f"{player_one} loses, {player_two} wins ")
        game_on = False
        break
    
    if len(player_two.all_cards) == 0:
        print(f"{player_two} loses, {player_one} wins ")
        game_on = False
        break

    # check done
    # the cards that will be displayed
    player_one_show_cards = []
    player_one_show_cards.append(player_one.play_one_card())

    player_two_show_cards = []
    player_two_show_cards.append(player_two.play_one_card())


    at_war = True
    while at_war:
        '''
        using -1 selects the last card in the stack,
        if there is a war

        if there's only 1 card then -1 selects just that card in the list
        '''
        if player_one_show_cards[-1].value > player_two_show_cards[-1].value:
            player_one_show_cards.extend(player_two_show_cards)
            player_one.add_cards(player_one_show_cards)
            # player_one_show_cards.clear()
            # player_two_show_cards.clear()
            at_war = False
            
        elif player_two_show_cards[-1].value > player_one_show_cards[-1].value:
            player_two_show_cards.extend(player_one_show_cards)
            player_two.add_cards(player_two_show_cards)
            # player_one_show_cards.clear()
            # player_two_show_cards.clear()
            at_war = False
        
        else:
            # this condition is when the displayed cards are of equal value
            print("WAR!")

            '''
            check to see if the player has at least 5 cards in their deck
            if it's less than 5 the player can't continue
            the higher the number the shorter the game
            this check is done for each player

            remember each player has 26 cards initially
            so essentially, 21 cards are used for the game
            '''
            if len(player_one.all_cards) < 5:
                print(f"{player_one} can't continue")
                print(f"{player_two} wins!")
                # ends entire process
                game_on = False
                break

            elif len(player_two.all_cards) < 5:
                print(f"{player_two} can't continue")
                print(f"{player_one} wins!")
                # ends entire process
                game_on = False
                break

            else:
                # each player has more than 5 cards left
                # Then add 5 cards to each players displayed cards
                
                for x in range(5):
                    player_one_show_cards.append(player_one.play_one_card())
                    player_two_show_cards.append(player_two.play_one_card())

                # cards added, now to check one by one
                # this is done by going to the theginning of the loop



    