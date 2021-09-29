# THE FOURTH STAGE
from game_functions import *

# FINAL GAME PLAY
while True:
    # print opening statement
    print("Hello the game is about to begin")

    # create and shuffle the deck, deal 2 cards to each player and dealer
    deck = Deck()
    deck.shuffle()

    player_hand = Hand()
    player_hand.add_card(deck.deal())
    player_hand.add_card(deck.deal())

    dealer_hand = Hand()
    dealer_hand.add_card(deck.deal())
    dealer_hand.add_card(deck.deal())
    
    # setup the player's chips
    player_chips = Chips()

    # prompt the player for their bet
    take_bet(player_chips)

    # show cards (but keep one dealer card hidden)
    show_some(player_hand, dealer_hand)

    while playing: #variable from hit_or_stand function

        # prompt for player to hit_or_stand
        hit_or_stand(deck, player_hand)

        # show cards (but keep one dealer card hidden)
        show_some(player_hand, dealer_hand)

        # If player's hand exceeds 21, run player_busts() and break out of loop
        if player_hand.value > 21:
            player_busts(player_hand, dealer_hand, player_chips)
            break

    # if players hasn't busted, play dealers hand
    if player_hand.value <= 21:

        while dealer_hand.value < player_hand.value:
            hit(deck, dealer_hand)

        # show all cards
        show_all(player_hand, dealer_hand)

        # Run different winning scenarios
        if dealer_hand.value > 21:
            dealer_busts(player_hand,dealer_hand,player_chips)
        elif dealer_hand.value > player_hand.value:
            dealer_wins(player_hand, dealer_hand, player_chips)
            print(f"The player's total number of chips is {player_chips.total}")
        elif dealer_hand.value < player_hand.value:
            player_wins(player_hand,dealer_hand,player_chips)
            print(f"The player's total number of chips is {player_chips.total}")
        else:
            push(player_hand, dealer_hand)

    # Ask if they would like to play again
    new_game = input("Would you like to play again? y/n: ")

    if new_game[0].lower() == 'y':
        playing = True
        continue
    else:
        print("Thank you for playing")
        break



        


    
        


    

        

