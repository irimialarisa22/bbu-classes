from Affine_cipher import AffineCipher

"""This is the menu of the application in that user input the data
"""
class UI:
    def __init__(self):
        pass

    def run(self):
        while True:
            try:
                option = input("""INSERT A COMMAND:\n1.ENCRYPTION\n2.DECRYPTION""")
                if option == "1":
                    a = (input("INSERT THE KEY a: "))
                    b = (input("INSERT THE KEY b: "))
                    text = input("INSERT THE TEXT: ")
                    aff = AffineCipher(a, b, text)
                    print(aff.encrypt())
                    print()
                elif option == "2":
                    a = (input("INSERT THE KEY a: "))
                    b = (input("INSERT THE KEY b: "))
                    text = input("INSERT THE TEXT: ")
                    aff = AffineCipher(a, b, text)
                    print(aff.decrypt())
                    print()
                else:
                    print("WRONG OPTION")
            except ValueError as e:
                print(e)