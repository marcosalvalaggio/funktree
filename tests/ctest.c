#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *name;
    int age;
    bool status;
} Dog;


struct point_2D {
    int x;
    int y;
};

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

int main() {
    Dog luna;
    dogInit(&luna, "luna", 9);
    dog_print(&luna);

    return 0;
}

