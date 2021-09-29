import datetime


class CarRental:
    def __init__(self, inventory):
        # initiates car rental shop
        self.inventory = inventory

    def show_inventory(self):
        print(f"There are {self.inventory} cars available")
        return self.inventory

    def rent_cars_hourly(self, number_of_cars):
        # rent car hourly to customer
        if 0< number_of_cars <= self.inventory:
            current_time = datetime.datetime.now()
            print(
                f"You've rented {number_of_cars} cars at {current_time.hour}:{current_time.minute} on {current_time.date()} "
            )
            print(f"You'll be charged $50 an hour")
            print("Thank you, Come again soon!")
            self.inventory -= number_of_cars
            return current_time

        elif number_of_cars > self.inventory:
            print("We don't have that many cars")
            print("Try checking how many cars are available")
            return None

        else:
            print("Number of cars should be greater than 0")
            return None

    def rent_cars_daily(self, number_of_cars):
        # rent car daily to customer
        if 0< number_of_cars <= self.inventory:
            current_time = datetime.datetime.now()
            print(
                f"You've rented {number_of_cars} cars at {current_time.hour}:{current_time.minute} on {current_time.date()} "
            )
            print(f"You'll be charged $800 a day")
            print("Thank you, Come again soon!")
            self.inventory -= number_of_cars
            return current_time

        elif number_of_cars > self.inventory:
            print("We don't have that many cars")
            print("Try checking how many cars are available")
            return None

        else:
            print("Number of cars should be positive")
            return None

    def rent_cars_weekly(self, number_of_cars):
        # rent car weekly to customer
        if 0 < number_of_cars <= self.inventory:
            current_time = datetime.datetime.now()
            print(
                f"You've rented {number_of_cars} cars at {current_time.hour}:{current_time.minute} on {current_time.date()} "
            )
            print(f"You'll be charged $4500 a week")
            print("Thank you, Come again soon!")
            self.inventory -= number_of_cars
            return current_time

        elif number_of_cars > self.inventory:
            print("We don't have that many cars")
            print("Try checking how many cars are available")
            return None

        else:
            print("Number of cars should be greater than 0")
            return None

    def return_car(self, request):
        """
        1. Accept a rented bike from a customer
        2. Replensihes the inventory
        3. Return a bill
        """
        bill = 0
        rental_basis, number_of_cars, rental_time = request

        # if values are assigned to rental_basis and rental_time
        # and number_of_cars then:
        if rental_basis and rental_time and number_of_cars:
            self.inventory += number_of_cars
            current_time = datetime.datetime.now()
            rental_period = current_time - rental_time

            # hourly bll calculation
            if rental_basis == 1:
                # cost = time * number of cars * price
                bill = round(rental_period.seconds / 3600) * number_of_cars * 5

            elif rental_basis == 2:
                # cost = time * number of cars * price
                bill = round(rental_period.days) * number_of_cars * 20

            elif rental_basis == 3:
                # cost = time * number of cars * price
                bill = round(rental_period.days) * number_of_cars * 60

            if 3 <= number_of_cars <= 10:
                print("you quallify for a 30% family rntal promotion ")
                bill = bill * 0.7

            print("Thank you for returning your car, come back again!")
            print(f"Your total bill is ${bill}")
            return bill
        else:
            print("Are you sure you borrowed a car from us?")
            return None


class Customer:
    def __init__(self):
        self.bill = 0
        self.rental_time = 0
        self.rental_basis = 0
        self.cars = 0

    def request_car(self):
        cars = input("How many cars would you like? ")

        try:
            cars = int(cars)
        except ValueError:
            print("That's not a positive integer")
            return -1

        if cars > 0:
            self.cars = cars
        else:
            print("Number of cars should be greater than 0")
            return -1

        return self.cars

    def return_car(self):
        if self.rental_basis and self.cars and self.rental_time:
            return self.rental_basis, self.cars, self.rental_time
        else:
            return 0, 0, 0
