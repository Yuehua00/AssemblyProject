#include <bits/stdc++.h>
using namespace std;

#define SIZE 4
#define border "---------------------------------"

int game[SIZE][SIZE];
int Row = 4, Col = 4;  // 可以以輸入更改
bool full = false;

void resetGame()
{
    game[SIZE][SIZE] = {0};
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

bool CreateNumber()
{
    int x = -1, y = -1;
    int times = 0;
    int max_times = Row * Col;
    int probablity = rand() % 3;    // 先跟她一樣，後面看要不要修改
    while(game[x][y] != 0 && times <= max_times)
    {
        x = rand() % Row;
        y = rand() % Col;
        times++;
    }

    if(times == max_times)
    {
        full = true;
        return false;        // 格子滿了
    }
    else
    {
        if(probablity == 0)
        {
            game[x][y] = 4;    // 1/3 機率
        }
        else
        {
            game[x][y] = 2;    // 2/3 機率
        }
    }
    return true;
}

void Process(char dir)
{
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
                    }
                    else
                    {
                        if(game[crow-1][col] == game[crow][col])    // 合併
                        {
                            game[crow-1][col] *= 2;
                            game[crow][col] = 0;
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
                    }
                    else
                    {
                        if(game[crow+1][col] == game[crow][col])
                        {
                            game[crow+1][col] *= 2;
                            game[crow][col] = 0;
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
                    }
                    else
                    {
                        if(game[row][ccol-1] == game[row][ccol])
                        {
                            game[row][ccol-1] *= 2;
                            game[row][ccol] = 0;
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
                    }else{
                        if(game[row][ccol + 1] == game[row][ccol]){
                            game[row][ccol + 1] *= 2;
                            game[row][ccol] = 0;
                        }
                    }
                }
            }
        }
        break;
    }
}

int Game_now()    // 遊戲狀況
{
    for(int i = 0; i < Row; i++)
    {
        for(int j = 0; j < Col; j++)
        {
            if(!game[i][j] || (game[i][j] == game[i][j+1]))
            {
                return 1;
                break;
            }
        }
    }
    for(int j = 0; j < Col; j++)
    {
        for(int i = 0; i < Row; i++)
        {
            if(!game[i][j] || (game[i][j] == game[i+1][j]))
            {
                return 1;
                break;
            }
        }
    }
    return 0;
}


int main()
{
    srand((unsigned int)time(0));
    CreateNumber();
    CreateNumber();
    print();
    char direction;
    int gameState = -1;
    while(true)
    {
        while(cin >> direction)
        {
            gameState = Game_now();
            //if(full) break;
            if(gameState == 1)
            {
                Process(direction);
                CreateNumber();
                print();
                break;
            }
            else if(gameState == 0)
            {
                print();
                cout <<"You lose!" << endl;
                break;
            }
        }

    }


    return 0;
}
