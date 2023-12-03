#include <bits/stdc++.h>
using namespace std;

#define SIZE 4
#define border "---------------------------------"

int game[SIZE][SIZE];
int Row = 4, Col = 4;  // �i�H�H��J���

void resetGame() {
    game[SIZE][SIZE] = {0};
}

enum GameNum {      // ��ı�o�i�H����...(?
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

bool CreateNumber(){
    int x = -1, y = -1;
    int times = 0;
    int max_times = Row * Col;
    int probablity = rand() % 3;    // ����o�@�ˡA�᭱�ݭn���n�ק�
    while(game[x][y] != 0 && times <= max_times){
        x = rand() % Row;
        y = rand() % Col;
    }

    if(times == max_times){
        return false;        // ��l���F
    }else{
        if(probablity == 0){
            game[x][y] = 4;    // 1/3 ���v
        }else{
            game[x][y] = 2;    // 2/3 ���v
        }
    }
    return true;
}

void Process(char dir){
    switch(dir){
        case 'w':  // up
            for(int row = 1; row < Row; row++){  //�̤W���@�椣��
                for(int crow = row; crow >= 1; --crow){  // ����
                    for(int col = 0; col < Col; col++){
                        if(game[crow-1][col] == 0){         // �W�@�Ƭ���
                            game[crow-1][col] = game[crow][col];
                            game[crow][col] = 0;
                        }else{
                            if(game[crow-1][col] == game[crow][col]){   // �X��
                                game[crow-1][col] *= 2;
                                game[crow][col] = 0;
                            }
                        }
                    }
                }
            }
            break;
        case 's':  // down
            for(int row = Row-2; row >= 0; row--){   //�̤U���@�椣��
                for(int crow = row; crow < Row-1; crow++){
                    for(int col = 0; col < Col; col++){
                        if(game[crow+1][col] == 0){
                            game[crow+1][col] = game[crow][col];
                            game[crow][col] = 0;
                        }else{
                            if(game[crow+1][col] == game[crow][col]){
                                game[crow+1][col] *= 2;
                                game[crow][col] = 0;
                            }
                        }
                    }
                }
            }
            break;
        case 'a':    // left
            for(int col = 1; col < Col; col++){
                for(int ccol = col; ccol >= 1; ccol--){
                    for(int row = 0; row < Row; row++){
                        if(game[row][ccol-1] == 0){
                            game[row][ccol-1] = game[row][ccol];
                            game[row][ccol] = 0;
                        }else{
                            if(game[row][ccol-1] == game[row][ccol]){
                                game[row][ccol-1] *= 2;
                                game[row][ccol] = 0;
                            }
                        }
                    }
                }
            }
            break;
        case 'd':  // right
    }
}


int main() {
    print();


    return 0;
}
