# THE THIRD STAGE

from card_classes import *


# GAME FUNCTIONS

# FUNCTION FOR TAKING BETS
def take_bet(chips):
    """
    takes in the chips class as an argument
    going to ask user for a bet a set the bet
    """
    while True:
        try:
            chips.bet = int(input('Please enter the number chips you are willing to bet: '))

            if chips.bet >= 70:
                print("YEAH! what's money to a cockroach! We've got a big spender!!!! but...")

            elif chips.bet <= 30:
                print("Come on! Live a little next time!!!")
        except:
            print('Whoops! put in a number(integer)')
        else:
            if chips.bet > chips.total:
                print(f"Sorry you do not have enough chips to place this bet, you have {chips.total}")
            else:
                print("lET'S GOOO!!!")
                break

# FUNCTION TO TAKE HITS
def hit(deck,hand):
    """
    adds dealt cards from deck to the hand of the player/dealer
    check for number of aces 
    """
    dealt_card = deck.deal()
    hand.add_card(dealt_card)
    hand.adjust_for_ace()

# FUNCTION TO HIT OR STAND
def hit_or_stand(deck,hand):
    global playing #will be used in while loop later
    """ 
    asks players to decide whether to hit or stand
    if they hit use function above, if they stand set game_on variable to False
    """
    
    while True:
        decision = input('Would you prefer to hit or stand? enter h or s: ')

        if decision.lower() == 's':
            print("Player stands, dealer's turn")
            playing = False

        elif decision.lower() == 'h':
            hit(deck,hand)

        else:
            print("Sorry wrong entry. Enter either hit or stand only" )
            continue

        break

# FUNCTIONS TO DISPLAY CARDS
def show_some(player, dealer):
    print("DEALERS HAND: ")
    print("one card hidden!")
    print(dealer.card[1])
    print('\n')
    print("PLAYER HAND: ")
    for card in player.card:
        print(card)

def show_all(player, dealer):
    print("DEALERS HAND: ")
    for card in dealer.card:
        print(card)
    print('\n')
    print("PLAYER HAND: ")
    for card in player.card:
        print(card)

# FUNCTION TO HANDLE END OF GAME SCENERIOS
def player_busts(player, dealer, chips):
    """
    player loses (value of cards in hand goes over 21)
    """
    print("PLAYER BUSTS, DEALER WINS")
    chips.lose_bet()

def dealer_busts(player, dealer, chips):
    """
    dealer loses (value of cards in hand goes over 21)
    """
    print("DEALER BUSTS, PLAYER WIN")
    chips.win_bet()

def player_wins(player, dealer, chips):
    print("PLAYER WINS, DEALER LOSES")
    chips.win_bet()

def dealer_wins(player, dealer, chips):
    print("DEALER WINS, PLAYER LOSES")
    chips.lose_bet()

def push(player, dealer):
    """
    A push happens when both player and dealer busts
    """
    print("DEALER AND PLAYER TIE! PUSH")