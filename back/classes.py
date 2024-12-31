class Person:
    def __init__(self, name, gender, family, isthere=True):
        self.name = name
        self.gender = gender
        self.family = family
        self.isthere = isthere if isthere else True

    def say_hello(self):
        print(f"Hello, my name is {self.name}")


class Family:
    def __init__(self, name, members):
        self.name = name
        self.members = members

