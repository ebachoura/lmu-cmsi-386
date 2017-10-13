import random
import math
import requests
from Crypto.Cipher import AES

def change(amount):
    if amount < 0:
        raise ValueError('amount cannot be negative')
    remaining = amount
    result = [None] * 4
    for index, value in enumerate((25, 10, 5, 1)):
        result[index], remaining = divmod(remaining, value)
    return tuple(result)

def strip_quotes(s):
    return s.translate(str.maketrans('', '', '\'"'))

def scramble(s):
    return ''.join(random.sample(s, len(s)))

def say(first_word=None):
    words = []
    def say_more(word=None):
        if word is None:
            return ' '.join(words)
        words.append(word)
        return say_more
    return say_more(first_word)

def triples(limit):
    result = []
    for c in range(1, limit + 1):
        for b in range(1, c):
            for a in range(1, b):
                if a * a + b * b == c * c:
                    result.append((a, b, c))
    return sorted(result, key=lambda x: x[0])

def powers(base, limit):
    current_value = 1
    while current_value <= limit:
        yield current_value
        current_value *= base

def interleave(a, *b):
    first_list, second_list, result = a, list(b), []
    while bool(first_list) and bool(second_list):
        result.append(first_list.pop(0))
        result.append(second_list.pop(0))
    return result + first_list + second_list

class Cylinder():
    def __init__(self, radius=1, height=1):
        self.radius = radius
        self.height = height
    @property
    def volume(self):
        return math.pi * (self.radius ** 2) * self.height
    @property
    def surface_area(self):
        return (2 * math.pi * (self.radius * self.height)) + (2 * math.pi * (self.radius ** 2))
    def widen(self, factor):
        self.radius *= factor
    def stretch(self, factor):
        self.height *= factor

def make_crypto_functions(key, iv):
    def encrypt(msg):
        return AES.new(key, AES.MODE_CBC, iv).encrypt(msg)
    def decrypt(cypher):
        return AES.new(key, AES.MODE_CBC, iv).decrypt(cypher)
    return [encrypt, decrypt]

def random_name(**payload):
    payload.update({'amount':1})
    r = requests.get('https://uinames.com/api/', params=payload)
    res = r.json()
    if 'error' in res:
        raise ValueError(res)
    return "{}, {}".format(res['surname'], res['name'])
