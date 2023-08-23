#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *name;
    int age;
    bool status;
} Dog;

int dogHumanAge(const Dog *dog) {
    return dog->age * 7;
}

void dogInit(Dog *dog, const char *name, int age) {
    dog->name = name;
    dog->age = age;
    dog->status = false;
}

void dogPrint(const Dog *dog) {
    printf("name: %s, age: %d\n", dog->name, dog->age);
}

int main() {
    Dog luna;
    dogInit(&luna, "luna", 9);
    dogPrint(&luna);

    return 0;
}

