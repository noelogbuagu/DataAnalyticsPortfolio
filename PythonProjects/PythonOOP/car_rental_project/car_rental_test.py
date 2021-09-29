import unittest
import car_rental
import datetime

class CarRentalTest(unittest.TestCase):
    '''
    typically test for:
    1. a zero entry
    2. negative number 
    3. valid positive number 
    4. Invalid positive number
    5. Do method specific testing
    '''
    def test_car_rental_shows_correct_inventory(self):
        autopalace1 = car_rental.CarRental(0)
        autopalace2 = car_rental.CarRental(10)
        self.assertEqual(autopalace1.show_inventory(), 0)
        self.assertEqual(autopalace2.show_inventory(), 10)
        
    # Rent Hourly Tests
    def test_rent_car_hourly_for_negative_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_hourly(-1), None)
        
    def test_rent_car_hourly_for_zero_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_hourly(0), None)
       
    def test_rent_car_hourly_for_valid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        hour = datetime.datetime.now().hour
        minute = datetime.datetime.now().minute
        self.assertEqual(autopalace.rent_cars_hourly(5).hour, hour)
        self.assertEqual(autopalace.rent_cars_hourly(5).minute, minute)
    
    def test_rent_car_hourly_for_invalid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_hourly(11), None)

    
        # Rent daily Tests
    def test_rent_car_daily_for_negative_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_daily(-1), None)
        
    def test_rent_car_daily_for_zero_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_daily(0), None)
       
    def test_rent_car_daily_for_valid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        hour = datetime.datetime.now().hour
        minute = datetime.datetime.now().minute
        self.assertEqual(autopalace.rent_cars_daily(5).hour, hour)
        self.assertEqual(autopalace.rent_cars_daily(5).minute, minute)
    
    def test_rent_car_daily_for_invalid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_daily(11), None)
    
    
    # Rent Weekly Tests
    def test_rent_car_weekly_for_negative_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_weekly(-1), None)
        
    def test_rent_car_weekly_for_zero_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_weekly(0), None)
       
    def test_rent_car_weekly_for_valid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        hour = datetime.datetime.now().hour
        minute = datetime.datetime.now().minute
        self.assertEqual(autopalace.rent_cars_weekly(5).hour, hour)
        self.assertEqual(autopalace.rent_cars_weekly(5).minute, minute)
    
    def test_rent_car_weekly_for_invalid_positive_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        self.assertEqual(autopalace.rent_cars_weekly(11), None)
        
    def test_for_invalid_rental_time(self):
        # create dealership and user
        autopalace = car_rental.CarRental(10)
        user = car_rental.Customer()
        
        # User wont rent a bike but will try to return one
        request = user.return_car()
        self.assertIsNone(autopalace.return_car(request))
        
        # Manually check return function with error values
        self.assertIsNone(autopalace.return_car((0,0,0)))
        
    def test_for_invalid_rental_basis(self):
        autopalace = car_rental.CarRental(10)
        user = car_rental.Customer()
        
        # create valid number of cars and rental time
        user.rental_time = datetime.datetime.now()
        user.cars = 10
        
        # but invalid rental_basis
        user.rental_basis = 8
        
        request = user.return_car()
        self.assertEqual(autopalace.return_car(request), 0)
        
    def test_for_invalid_number_of_cars(self):
        autopalace = car_rental.CarRental(10)
        user = car_rental.Customer()
        
        # create valid rental_time and rental_basis
        user.rental_time = datetime.datetime.now()
        user.rental_basis = 1
        
        # invalid number of cars
        user.cars = 800
        
        request = user.return_car()
        self.assertEqual(autopalace.return_car(request), 0)
        
    def test_retrun_car_for_valid_input(self):
        
        # create dealership and various users
        autopalace = car_rental.CarRental(100)
        user1 = car_rental.Customer()
        user2 = car_rental.Customer()
        user3 = car_rental.Customer()
        user4 = car_rental.Customer()
        user5 = car_rental.Customer()
        user6 = car_rental.Customer()
        
        # create a valid rental_basis, rental_time and number of cars
        
        # rental basis
        user1.rental_basis = 1 #hourly
        user2.rental_basis = 1 #hourly
        user3.rental_basis = 2 #daily
        user4.rental_basis = 2 #daily
        user5.rental_basis = 3 #weekly
        user6.rental_basis = 3 #weekly
        
        # rental_time
        user1.rental_time = datetime.datetime.now() + datetime.timedelta(hours=-4)
        user1.rental_time = datetime.datetime.now() + datetime.timedelta(hours=-23)
        user2.rental_time = datetime.datetime.now() + datetime.timedelta(days=-4)
        user2.rental_time = datetime.datetime.now() + datetime.timedelta(days=-13)
        user3.rental_time = datetime.datetime.now() + datetime.timedelta(weeks=-6)
        user3.rental_time = datetime.datetime.now() + datetime.timedelta(weeks=-12)
        
        # number_of_cars
        user1.cars = 1
        user2.cars = 5 #User2 is eligible for family discount
        user3.cars = 2
        user4.cars = 8
        user5.cars = 15
        user6.cars = 30
        
        # Make valid requests 
        request1 = user1.return_car()
        request2 = user2.return_car()
        request3 = user3.return_car()
        request4 = user4.return_car()
        request5 = user5.return_car()
        request6 = user6.return_car()
        
        # Check if all the bills are correct
        # self.assertEqual(autopalace.return_car(request1), calculate bill)
        # self.assertEqual(autopalace.return_car(request2), #calculate bill)
        # self.assertEqual(autopalace.return_car(request3), #calculate bill)
        # self.assertEqual(autopalace.return_car(request4), #calculate bill)
        # self.assertEqual(autopalace.return_car(request5), #calculate bill)
        # self.assertEqual(autopalace.return_car(request6), #calculate bill)
        
class CustomerTest(unittest.TestCase):
    
    def return_car_with_valid_input(self):
        
        user = car_rental.Customer()
        
        now= user.rental_time = datetime.datetime.now()
        user.rental_basis = 2
        user.cars = 6
        
        self.assertEqual(user.return_car(), (2,6,now))
        
    def return_car_with_invalid_input(self):
        
        user = car_rental.Customer()
        
        now= user.rental_time = datetime.datetime.now()
        user.rental_basis = 0
        user.cars = 6
        
        self.assertEqual(user.return_car(), (0,0,0))
        
             
if __name__=="__main__":
    unittest.main()
       
    
    