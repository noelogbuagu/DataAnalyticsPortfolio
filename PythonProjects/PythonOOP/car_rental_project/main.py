import car_rental


def main():
    autopalace = car_rental.CarRental(50)
    user = car_rental.Customer()

    while True:
        print(
            """
        ====== Car Rental Shop =======
        1. Display available cars
        2. Request a car on hourly basis $50
        3. Request a car on daily basis $800
        4. Request a car on weekly basis $4500
        5. Return a car
        6. Exit
        """
        )

        decision = input("Please pick between 1-6: ")

        try:
            decision = int(decision)
        except ValueError:
            print("That's not an int!")
            continue

        if decision == 1:
            autopalace.show_inventory()

        # bill for hourly rent
        elif decision == 2:
            # user.request_car ask for the number of cars the user wants to rent
            # it also returns that number

            # autopalace.rent_cars_(hourly,daily,weekly) takes in the number of cars
            # and subtracts that number from inventory
            # Also, returns the time the rent request was made
            # that is assigned to the user.rental time
            user.rental_time = autopalace.rent_cars_hourly(user.request_car())
            user.rental_basis = 1

        # bill for daily
        elif decision == 3:
            user.rental_time = autopalace.rent_cars_daily(user.request_car())
            user.rental_basis = 2

        elif decision == 4:
            user.rental_time = autopalace.rent_cars_weekly(user.request_car())
            user.rental_basis = 3

        elif decision == 5:
            # user.return_car() returns the rental_basis,
            user.bill = autopalace.return_car(user.return_car())
            # resets all to 0
            user.rental_basis, user.cars, user.rental_time = 0, 0, 0

        elif decision == 6:
            break

        else:
            print("Please pick between 1 - 6")

    print("Thank you for coming to Autopalace")


if __name__ == "__main__":
    main()