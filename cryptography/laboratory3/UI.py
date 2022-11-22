
"""This is the menu of the application in that user input the data
"""
from RSA import RSA, test_prime


class UI:
    def __init__(self):
        self.rsa = None
        self.res = []

    def run(self):
        prime1 = -1
        prime2 = -1
        while True:  # abcdefghijklmnopqrstuvwxyz
            try:
                option = input("""INSERT A COMMAND:\n0.EXIT\n1.ENCRYPTION\n2.DECRYPTION""")
                if option == "0":
                    print('THE PROGRAMME HAS STOPPED')
                    break
                elif option == "1":
                    prime1 = input("GIVE THE FIRST PRIME NUMBER: ")
                    prime2 = input("GIVE THE SECOND PRIME NUMBER ")
                    if not test_prime(int(prime1)) or not test_prime(int(prime2)):
                        print("WRONG INPUT!\n")

                    self.rsa = RSA(int(prime1), int(prime2))

                    message = input("GIVE THE MESSAGE: ")
                    self.res = self.rsa.encrypt(message)
                    print(self.res)
                elif option == "2":
                    try:
                        message = self.rsa.decrypt(self.res)
                        print(message)
                    except AttributeError as e:
                        print(str(e) + "\nRSA NOT CREATED YET!")
                else:
                    print("WRONG OPTION!\n")
            except ValueError as e:
                print(e)
