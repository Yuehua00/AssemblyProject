#include <bits/stdc++.h>
using namespace std;

#define SIZE 4
#define border "---------------------------------"

int game[SIZE][SIZE];
int Row = 4, Col = 4;  // 可以以輸入更改
bool full = false;

void resetGame()
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            game[i][j] = 0;
}

void print()
{
    for (int i = 0; i < SIZE; i++)
    {
        cout << border << endl;

        for (int j = 0; j < SIZE; j++)
        {
            if (!game[i][j]) cout << "|   \t";
            else cout << "|   " << game[i][j] << "\t";
        }
        cout << "|" << endl;
    }
    cout << border << endl;
}

int Game_now()    // 遊戲狀況
{
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (game[i][j] == 2048) return 2;
        }
    }

    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (!game[i][j]) return 1;
            else {
                if (i + 1 < SIZE) {
                    if (game[i][j] == game[i+1][j]) return 1;
                }
                else if (j + 1 < SIZE) {
                    if (game[i][j] == game[i][j+1]) return 1;
                }
            }
        }
    }

    return 0;
}

bool CreateNumber()
{
    int x, y;
    int probablity = rand() % 3;    // 先跟她一樣，後面看要不要修改

    if (Game_now() == 0) return false;

    while(true) {
        x = rand() % Row;
        y = rand() % Col;

        if (game[x][y] == 0) break;
    }

    if(probablity == 0) game[x][y] = 4;    // 1/3 機率
    else game[x][y] = 2;    // 2/3 機率

    return true;
}

int Process(char dir)
{
    int change = 0;

    switch(dir)
    {
    case 'w':  // up
        for(int row = 1; row < Row; row++)   //最上面一行不動所以從1開始
        {
            for(int crow = row; crow >= 1; --crow)   // 不懂
            {
                for(int col = 0; col < Col; col++)
                {
                    if(game[crow-1][col] == 0)          // 上一排為空
                    {
                        game[crow-1][col] = game[crow][col];
                        game[crow][col] = 0;
                        if (game[crow-1][col]) change++;
                    }
                    else
                    {
                        if(game[crow-1][col] == game[crow][col])    // 合併
                        {
                            game[crow-1][col] *= 2;
                            game[crow][col] = 0;

                            change++;
                        }
                    }
                }
            }
        }
        break;
    case 's':  // down
        for(int row = Row-2; row >= 0; row--)    //最下面一行不動
        {
            for(int crow = row; crow < Row-1; crow++)
            {
                for(int col = 0; col < Col; col++)
                {
                    if(game[crow+1][col] == 0)
                    {
                        game[crow+1][col] = game[crow][col];
                        game[crow][col] = 0;

                        if (game[crow+1][col]) change++;
                    }
                    else
                    {
                        if(game[crow+1][col] == game[crow][col])
                        {
                            game[crow+1][col] *= 2;
                            game[crow][col] = 0;

                            change++;
                        }
                    }
                }
            }
        }
        break;
    case 'a':    // left
        for(int col = 1; col < Col; col++)
        {
            for(int ccol = col; ccol >= 1; ccol--)
            {
                for(int row = 0; row < Row; row++)
                {
                    if(game[row][ccol-1] == 0)
                    {
                        game[row][ccol-1] = game[row][ccol];
                        game[row][ccol] = 0;

                        if (game[row][ccol-1]) change++;
                    }
                    else
                    {
                        if(game[row][ccol-1] == game[row][ccol])
                        {
                            game[row][ccol-1] *= 2;
                            game[row][ccol] = 0;

                            change++;
                        }
                    }
                }
            }
        }
        break;
    case 'd':  // right
        for(int col = Col - 2; col >= 0; col--)
        {
            for(int ccol = col; ccol <= Col - 2; ccol++)
            {
                for(int row = 0; row < Row; row++)
                {
                    if(game[row][ccol + 1] == 0)
                    {
                        game[row][ccol + 1] = game[row][ccol];
                        game[row][ccol] = 0;

                        if (game[row][ccol+1]) change++;
                    }
                    else{
                        if(game[row][ccol + 1] == game[row][ccol]){
                            game[row][ccol + 1] *= 2;
                            game[row][ccol] = 0;

                            change++;
                        }
                    }
                }
            }
        }
        break;
    }

    return change;
}

int main()
{
    char play = 'Y';
    srand((unsigned int)time(0));
    char direction;
    int gameState;

    while(play == 'Y')
    {
        resetGame();
        CreateNumber();
        CreateNumber();
        print();  // Q只有出現一個數字
        gameState = Game_now();

        while(gameState == 1) {
            cin >> direction;
            if (Process(direction) > 0)
                CreateNumber();
            print();
            gameState = Game_now();
        }

        if(gameState == 0)
            cout <<"You lose!" << endl;
        else
            cout << "You win!" << endl;

        cout << "Do you want to play again? Y/N" << endl;
        cin >> play;
    }
    cout << "Thanks for playing!" << endl;


    return 0;
}
