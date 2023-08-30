
#include <iostream>
#include <stdio.h>
#include <stdbool.h>


class Person {
    public:
        const char* name;
        int age;
        
        void printPerson() {
            std::cout << name << age << std::endl;
        }

        int* test_foo() {
            int* result = new int(42);
            return result;
        }
            
};


typedef struct {
    const char *name;
    int age;
    bool status;
} Dog;

struct point_2D {
    int x;
    int y;
};

enum Color {
    RED,
    GREEN,
    BLUE
}; 

typedef enum {
    Working,
    Failed,
    Freezed
} State;

int dogHumanAge(const Dog *dog) {
    return dog->age * 7;
}

void dogInit(Dog *dog, const char *name, int age) {
    dog->name = name;
    dog->age = age;
    dog->status = false;
}

void dog_print(const Dog *dog) {
    printf("name: %s, age: %d\n", dog->name, dog->age);
}

int* test_foo() {
    int* result = new int(42);
    return result;
}

int main() {
    Dog luna;
    dogInit(&luna, "luna", 9);
    dog_print(&luna);

    return 0;
}
