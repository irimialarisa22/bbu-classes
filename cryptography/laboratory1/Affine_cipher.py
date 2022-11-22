from Validator import Validator

"""
I used classes because I can structure my data and functions more easily inside a class
To encrypt a message we use the following formula : y = (a*x +b) mod 27, where 27 is the size of the alphabet
To encrypt a message we use the following formula : x = a^(-1)*(y-b) mod 27
the alphabet is the collection of character that we're going to use in the program
a and b are the keys
text is the text input by the user, reduced to upper case
The most import thing: when we want to decrypt a text it has to be copied from encryption
"""


class AffineCipher:
    def __init__(self, newA, newB, newText):
        self.alphabet = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        self.a = newA
        self.b = newB
        self.text = newText.upper()

    def validate_input(self):
        v = Validator(self)
        v.validate()

    """ We iter through the letters and encrypt them using the mentioned formula
    """

    def encrypt(self):
        self.validate_input()
        encrypted_text = ""
        for letter in self.text:
            encrypted_text += self.get_encryption(letter)
        return encrypted_text

        """Compute the encryption for a given letter
        """

    def get_encryption(self, letter):
        index = self.alphabet.index(letter)
        return self.alphabet[self.modulo(self.a * index + self.b, len(self.alphabet))]

    def modulo(self, x, n):
        """
        (x // n) - represents the floor of the x/n quantity.
        n * (x // n) - represents the biggest multiple of n lower or equal to x
        x - n * (x // n) - represents the remainder, the result of the modulo operation
        :param x: number with we're going to operate( it is integer strictly positive or 0)
        :param n: number we're going to divide (modulo) (it is integer strictly positive)
        :return: number mod n (positive integer in  [0,x) interval)
        """
        mod = x - n * (x // n)
        return mod

    """ We iter through the letters and decrypt them using the inverse of the mentioned formula
    """

    def decrypt(self):
        self.validate_input()
        a_inverse = self.modular_inverse(self.a, len(self.alphabet))
        decrypted_text = ""
        for letter in self.text:
            decrypted_letter = self.get_decryption(letter, a_inverse, self.b)
            decrypted_text += decrypted_letter
        return decrypted_text

    """Compute the decryption for a given letter
    """

    def get_decryption(self, letter, a_inverse, b):
        index = self.alphabet.index(letter)
        encrypted_letter = self.alphabet[self.modulo(a_inverse * (index - b), len(self.alphabet))]
        return encrypted_letter

    """Compute the inverse of the mentioned formula
    """

    def modular_inverse(self, a, m):
        inverse = extended_gcd(a, m)[1]
        if inverse < 0:
            inverse = inverse + m
        return inverse


def extended_gcd(a, b):
    """
    The function takes positive integers a, b as input, and return a triplet (g, x, y), such that ax + by = g = gcd(a, b)
    :param a: the first number
    :param b: the second number
    (a and b are strictly positive integers)
    :return: extended greatest common divisor of a and b (strictly positive integer)
    """
    if a == 0:
        return b, 0, 1
    else:
        gcd, x, y = extended_gcd(b % a, a)
        """Unpack the results of recursive call( recursive call determines basic gcd(a,b)) in the gcd, x, y variables """
        return gcd, y - (b // a) * x, x
