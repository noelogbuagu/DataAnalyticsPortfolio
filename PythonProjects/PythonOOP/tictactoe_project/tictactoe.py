# Creation of a Tick-Tack-Toe game
import random

# STEP 1: creating a function that prints out the board for the game 
# and assigns positions to the board.
def display_board(board):
    """
    Takes in a board list and assigns content of the list to the display board.
    The contents displayed on the board will match the index of the content in the board list.
    The content of the list are strings.
    """
    print('\n'*100)
    print(board[1] + '|' + board[2] + '|' + board[3])
    print('-----')
    print(board[4] + '|' + board[5] + '|' + board[6])
    print('-----')
    print(board[7] + '|' + board[8] + '|' + board[9])


# STEP 2: Functiion that takes in a player input x
# and assigns their markers 'X' and 'O'
def player_input():
    """
    use a while loop to continuously ask for input 
    and assign markers as value inputed (X or O)
    the loop should break if the wrong type of anser is given
    OUTPUT = (player1_marker, player2_marker)
    """
    marker = ''

    while not (marker == 'X' or marker == 'O'):
        marker = input('Player 1, X or O?: ').upper()

    # player2 is using the other marker that's not picked
    if marker == 'X':
        return ('X','O')
    else:
        return ('O','X')


# STEP 3: Write a function that takes in the board list object, a marker('X' or 'O)
# and a desired position(1-9) and assigns it to the board.
def place_marker(board, marker, position):
    """
    this is used to place the marker on the right position on the board
    """
    board[position] = marker


# STEP 4: Write a function that takes in a board and 
# a mark(X or O) and checks to see if that mark has won
def win_check(board, mark):
    """
    this checks the conditions for winning
    rows
    1. the same marker in positions 1,2,3
    2. the same marker in positions 4,5,6
    3. the same marker in positions 7,8,9
    columns
    4. the same marker in positions 1,4,7
    5. the same marker in positions 2,5,8
    6. the same marker in positions 3,6,9
    diagonals
    7. the same marker in positions 1,5,9
    8. the same marker in positions 3,5,7
    """
    if (board[1] == mark and board[2] == mark and board[3] == mark):
        return True
    elif (board[4] == mark and board[5] == mark and board[6] == mark):
        return True
    elif (board[7] == mark and board[8] == mark and board[9] == mark):
        return True
    elif (board[1] == mark and board[4] == mark and board[7] == mark):
        return True
    elif (board[2] == mark and board[5] == mark and board[8] == mark):
        return True
    elif (board[3] == mark and board[6] == mark and board[9] == mark):
        return True
    elif (board[1] == mark and board[5] == mark and board[9] == mark):
        return True
    elif (board[3] == mark and board[5] == mark and board[7] == mark):
        return True


# STEP 5: Function that uses the random module 
# to randomly decide which player goes first. 
# return a string of which player plays first
def choose_first():
    """
    use the random module to decide who goes first
    """
    result = random.randint(0,1)
    
    if result == 0:
        return 'Player 1'
    else:
        return 'Player 2'

# STEP 6: Write a function that returns a boolean 
# indicating whether a space on the board is freely available
def space_check(board, position):
    """
    A position is available if there is no marker at that positon
    """
    return board[position] == ' '
    

# STEP 7: Write a function that checks if the board is full and 
# returns a boolean value. True if full, Fase if otherwise 
def full_board_check(board):
    """
    the board is full if every position on the board has a mark(X or O)
    go through every position and check if the spack is occupied
    """
    for i in range(len(board)):
        if space_check(board, i):
            return False
    return True

# STEP 8: Write a function that continuously asks for a player's next position (1-9) 
# and then uses the function from STEP 6 to check if it's a free position. 
# If it is, then return the position for later use.
def player_choice(board):
    """
    ask for position choice and assign the players choice to a variable.
    question should be asked till there's no need to ask anymore
    use that result for the paramenter in function 6.
    if the position is free, return it.
    """
    position = 0

    # the first condition checks to see if they are inputing the wrong number or a letter(edge case)
    # the second condition checks to see if that space is still available

    while position not in range(len(board)) or not space_check(board, position):
        position = int(input('Please pick a poisition from 1-9: '))
    
    return position

# STEP 9: Write a function that asks the players if they want to play again 
# return True if they do, false if they don't
def replay():
    """
    determine if the players want another game or not.
    if Yes, return True. Else, return False.
    """
    result = input('Would you like to play again (y/n): ')

    return result == 'y' 

# # PUTTING IT ALL TOGETHER
# # A while loop keeps the entire game running
print('May The Games Begin')

while True:

    # Game will be set up here
    # The first things are drawing the board, deciding who goes first and then deciding who is X or O
    board = [' ']*10
    player1_marker, player2_marker = player_input()
    turn = choose_first()
    print(turn + ' starts')

    begin_game = input('Ready? y/n: ')

    if begin_game == 'y':
        game_on = True
    else:
        game_on = False

    # Gameplay
    while game_on:
        if turn == 'Player 1':
            # player 1 turn
            # show board
            display_board(board)

            # choose a position
            position = player_choice(board)

            # Place the marker on the position
            place_marker(board, player1_marker, position)

            # check if they won
            if win_check(board, player1_marker):
                display_board(board)
                print('Player 1 Won!!!!!')
                game_on = False
            else:
                # check if there is a tie
                # there is a tie if the board is full and there is no winner
                if full_board_check(board):
                    display_board(board)
                    print('The game is a tie, sigh')
                    game_on = False
                else:
                    turn = 'Player 2'

            # no draw or no win? player 2's turn
        else:
            #player 2 turn
            # show board
            display_board(board)

            # choose a position
            position = player_choice(board)

            # Place the marker on the position
            place_marker(board, player2_marker, position)

            # check if they won
            if win_check(board, player2_marker):
                display_board(board)
                print('Player 2 Won!!!!!')
                game_on = False
            else:
                # check if there is a tie
                # there is a tie if the board is full and there is no winner
                if full_board_check(board):
                    display_board(board)
                    print('The game is a tie, sigh')
                    game_on = False
                else:
                    turn = 'Player 1'
    
    if not replay():
        break
    # Break out to the beginning





    
    


   
    
    
