
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age
        self._status = False

    def human_age(self):
        return self.age * 7

    def __repr__(self):
        return f"name: {self.name}, age: {self.age}"

def main():
    luna = Dog(name="luna", age=9)
    print(luna)

if __name__ == "__main__":
    main()
