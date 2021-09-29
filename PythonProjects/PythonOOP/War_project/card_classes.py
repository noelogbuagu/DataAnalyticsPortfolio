# THE SECOND STAGE

from deck_components import *

class Card:
    """
    class has 2 attributes: rank and suit
    """

    def __init__(self, rank, suit):
        """
        rank refers to the number on the card
        suite refers to the type of card
        """
        self.rank = rank
        self.suit = suit
        self.value = values[rank]

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

    def deal_one(self):
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

# A representation of the player's hand
class Player:
    """
    holds card objects
    calculates value of the cards
    """
    def __init__(self,name):
        """
        self.card is an empty list that holds dealt cards
        name is to differentiate between players
        """
        self.name = name
        self.all_cards = []

    def play_one_card(self):
        '''
        plays card from the top of the player hand
        '''
        return self.all_cards.pop(0)

    def add_cards(self,card):
        """
        Adds card won
        """
        # checks if card is a list of multiple cards
        if type(card) == list:
            self.all_cards.extend(card)
        # condition for a single card
        else:
            self.all_cards.append(card)

    def __str__(self):
        '''
        prints number of cards a player has
        '''
        return f"{self.name} has {len(self.all_cards)} card(s) and"
        



