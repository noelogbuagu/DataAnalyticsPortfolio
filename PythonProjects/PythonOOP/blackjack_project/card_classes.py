# THE SECOND STAGE


# from PythonLearning.blackjack_project.deck_components import *
from deck_components import *

class Card:
    """
    class has 2 attributes: rank and suite
    """

    def __init__(self, rank, suit):
        """
        rank refers to the number on the card
        suite refers to the type of card
        """
        self.rank = rank
        self.suit = suit

    def __str__(self):
        """
        prints out a string representation of a printed card
        """
        return f"{self.rank} of {self.suit}"

class Deck:
    """
    Need to store the 52 card deck in a list that can be shuffled
    Need to instantiate all 52 unique card objects
    Need to iterate over sequences of ranks and suits to build the deck
    """

    def __init__(self):
        """
        deck is not taken in as a parameter even though it is an attribute
        This is because you want the deck of cards to be the same everytime
        making it a parameter would allow users to change it
        """
        self.deck = []

        # creats a list of each suit with a corresponding rank
        # it then appends all to the empty self.deck list
        for suit in suits:
            for rank in ranks:
                # uses the entire Card class here
                # create the card object
                created_card = Card(rank, suit)
                self.deck.append(created_card)

    def shuffle(self):
        """
        responsible for shuffling the deck of cards
        """
        random.shuffle(self.deck)

    def deal(self):
        """
        responsible for distributing the cards
        """
        # this allows me to use the shuffle method
        # in the deal method
        # So, the deck is shuffled before it's dealt
        self.shuffle()
        the_card = self.deck.pop()
        return the_card

    def __str__(self):
        """
        responsible for printing out the contents
        of the deck for trouble shooting purposes
        """
        deck_content = ""

        for card in self.deck:
            # uses the string representation in the Card class
            deck_content += "\n" + card.__str__()

        return deck_content


# A representation of the player or the dealer
class Hand():
    """
    holds card objects
    calculates value of the cards
    adjusts for the value of aces when appropriate
    """
    def __init__(self):
        """
        self.card is an empty list that holds dealt cards
        values is immediately assigned too zero
        aces is assigned to 0 to keep track of number of aces
        """
        self.card = []
        self.value = 0
        self.aces = 0

    def add_card(self,card):
        """
        Adds cards dealt from the deck class [Deck.deal()]
        """
        self.card.append(card)
        self.value += values[card.rank]

        # keep track of the number of aces
        if card.rank == 'Ace':
            self.aces += 1            

    def adjust_for_ace(self):
        """
        checks to see the correct value of ace to add
        check for current value in hand
        From values dictionary ace is always 11
        so need to check if the total value > the limit(21)
        """
        # IF total value > 21 and there is still an ace
        # then change ace to be 1 instead of the preset 11
        while self.value > 21 and self.aces >0:
            self.value -= 10
            self.aces -= 1

class Chips():
    """
    keeping track of the player's:
    starting chips, bets, ongoing winnings
    """
    def __init__(self):
        # self.total can be set to a default value
        # or supplied by a user input
        self.total = 100
        self.bet = 0

    def win_bet(self):
        self.total += self.bet

    def lose_bet(self):
        self.total -= self.bet