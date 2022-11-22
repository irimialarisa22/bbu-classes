import math
""" I validated the input from user
"""
class Validator:
    def __init__(self, entity):
        self.ntt = entity
    def validate(self):
        exception = ''
        for character in self.ntt.text:
            if character not in 'QWERTYUIOPASDFGHJKLZXCVBNM ':
                exception += 'CANNOT INTRODUCE NON-ALPHA CHARACTERS AS TEXT!\n'
        try:
            self.ntt.a = int(self.ntt.a)
            if math.gcd(self.ntt.a, len(self.ntt.alphabet)) != 1:
                raise ValueError()
        except ValueError:
            exception += 'KEY "A" MUST BE A POSITIVE INTEGER WITH NO COMMON DIVISORS WITH THE SIZE OF THE ALPHABET!\n'

        try:
            self.ntt.b = int(self.ntt.b)
        except ValueError:
            exception += 'KEY "B" MUST BE A POSITIVE INTEGER!\n'

        if len(exception) > 0:
            raise ValueError(exception)
