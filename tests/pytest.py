
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age
        self._status = False

    def human_age(self):
        return self.age * 7

    def __repr__(self):
        return f"name: {self.name}, age: {self.age}"

    def long_method_func(self, param_a, param_b, param_c,
                         param_d, param_e):
        return f"{param_a, param_b, param_c, param_d, param_e}"

def main():
    luna = Dog(name="luna", age=9)
    print(luna)

if __name__ == "__main__":
    main()
