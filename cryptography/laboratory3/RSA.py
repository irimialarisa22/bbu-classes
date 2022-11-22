from math import sqrt
from random import randint

"""
The function computes the greatest common divisor of two integer numbers
:param a: positive integer
:param b: positive integer
:returns: integer representing the greatest common divisor of a and b 
"""
def gcd(a, b):
    if b == 0:
        return a
    else:
        return gcd(b, a % b)


"""
The function verifies if an integer number is prime or not
:param prime: positive integer greater than 1
:returns: boolean value - True if the number is prime and False if not 
"""
def test_prime(prime):
    divisor = 2
    while divisor < sqrt(prime):
        if prime % divisor == 0:
            return False
        divisor += 1
    return True


"""
ϕ function
:param p: prime number
:param q: prime number
:returns: positive integer
"""
def phi(p, q):
    return (p - 1) * (q - 1)


"""
I used classes because I can structure my data and functions more easily inside a class
Class encapsulating the methods used for encrypting and decrypting data using the RSA algorithm
:param computedRnd: boolean value telling us whether the e has been computed or not yet
:param p: first prime number
:param q: second prime number
:param n: product p * q 
:param t: value of ϕ(n)
:param e: random number with the following properties: 1 < e < ϕ(n) and gcd(e, ϕ(n)) == 1
"""
class RSA:
    def __init__(self, p, q):
        self.computedRnd = False
        self.p = p
        self.q = q
        self.n = p * q
        self.t = phi(p, q)
        self.e = self.select_untill_gcd_1()

    """
    If the 'computedRnd' tells us that the e value has not been computed yet,
     then we enter an infinite loop where we randomly generate a number between 1 and  ϕ(n).
     If that value and ϕ(n) are coprime, then we stop looping, knowing that we have found e;
     else, we will keep generating random numbers until we will have found the right one.
    :returns: positive integer having the following properties: 1 < e < ϕ(n) and gcd(e, ϕ(n)) == 1
    """
    def select_untill_gcd_1(self):
        if self.computedRnd is False:
            self.computedRnd = True
            while True:
                self.e = randint(2, self.t-1)
                if gcd(self.e, self.t) == 1:
                    return self.e
        else:
            return self.e

    """
    :returns: the public key of the encryption algorithm (e, n)
    """
    def get_encryption(self):
        return self.e, self.n

    """
    :returns: the private key of the decryption algorithm (d)
    """
    def get_decryption(self):
        d = self.modinv(self.e, self.t)
        return d, self.n

    """
    The function takes positive integers a, b as input, and return a triplet (g, x, y), such that ax + by = g = gcd(a, b)
    :param a: the first number
    :param b: the second number
    (a and b are strictly positive integers)
    :return: extended greatest common divisor of a and b (strictly positive integer)
    """
    def extended_gcd(self, a, b):
        if a == 0:
            return b, 0, 1
        else:
            """Unpack the results of recursive call( recursive call determines basic gcd(a,b)) in the gcd, x, y variables """
            g, y, x = self.extended_gcd(b % a, a)
            return g, x - (b // a) * y, y

    """
    The function computes the modular inverse of an integer number
    :param a: positive integer
    :param m: positive integer
    :returns: modular inverse of a and m ( a^(-1) )
    """
    def modinv(self, a, m):
        g, x, y = self.extended_gcd(a, m)
        if g != 1:
            raise Exception('MODULAR INVERSE DOES NOT EXIST')
        else:
            return x % m

    """
    The function computes the encryption of the text
    :param message: string message that we will encrypt
    :returns: list of encrypted values 
    """
    def encrypt(self, message):
        encryption = []
        for character in message:
            m = ord(character)  # Return the Unicode code point for a one-character string.
            encryption.append(self.compute_encryption_for_character(m))
        return encryption

    """
    The function computes the  repetead squaring modular exponentiation
    :param m: not encrypted character
    :returns: integer representing the encrypted value of 'm' 
    """
    def compute_encryption_for_character(self, m):
        return (m**self.e) % self.n

    """
    The function computes the decryption of the text
    :param encryption: integer representing an encrypted value of a character
    :returns: character representing the decrypted value of 'encryption'
    """
    def decrypt(self, encryption):
        message = " "
        d, n = self.get_decryption()
        for c in encryption:
            m = (c**d) % n
            character = chr(m)
            message += character
        return message