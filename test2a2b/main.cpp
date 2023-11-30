#include <bits/stdc++.h>
using namespace std;

#define SIZE 4
#define border "---------------------------------"

int game[SIZE][SIZE];

void resetGame() {
    game[SIZE][SIZE] = {0};
}

enum GameNum {
    Game_2 = 2,
    Game_4 = 4,
    Game_8 = 8,
    Game_16 = 16,
    Game_32 = 32,
    Game_64 = 64,
    Game_128 = 128,
    Game_256 = 256,
    Game_512 = 512,
    Game_1024 = 1024,
    Game_2048 = 2048,
};

void print() {
    for (int i = 0; i < SIZE; i++) {
        cout << border << endl;

        for (int j = 0; j < SIZE; j++) {
            if (!game[i][j]) cout << "|   \t";
            else cout << "|   " << game[i][j] << "\t";
        }
        cout << "|" << endl;
    }
    cout << border << endl;
}





int main() {
    print();
    return 0;
}
