#include <iostream>
#include <cstdlib>
#include <ctime>
#include <vector>

using namespace std;

int main() {
    cout << "共有4位數，每個數字都不重複\n若數字對位子不對，為B\n若數字對位子也對，則為A\n";

    srand(time(0));
    int play = 1;

    while (play) {
        int a, b, c, d;
        vector<int> asn;
        a = rand() % 9 + 1;
        do {
            b = rand() % 9 + 1;
        } while (b == a);
        do {
            c = rand() % 9 + 1;
        } while (c == a || c == b);
        do {
            d = rand() % 9 + 1;
        } while (d == a || d == b || d == c);

        asn.push_back(a);
        asn.push_back(b);
        asn.push_back(c);
        asn.push_back(d);

        int A = 0;
        int B = 0;
        int y = 0; // 猜的次數

        while (A != 4) {
            int num;
            cout << "請輸入你猜的值: ";
            cin >> num;

            y++;

            int p = num / 1000;
            int q = num / 100 % 10;
            int r = num % 100 / 10;
            int s = num % 10;

            vector<int> guss = {p, q, r, s};

            for (int i = 0; i < 4; i++) {
                for (int t = 0; t < 4; t++) {
                    if (guss[i] == asn[t]) {
                        B++;
                    }
                }
            }

            for (int x = 0; x < 4; x++) {
                if (asn[x] == guss[x]) {
                    A++;
                    B--;
                }
            }

            cout << A << "A" << B << "B\n";

            if (A != 4) {
                A = 0;
                B = 0;
            }
        }

        cout << "你猜對了\n共猜了" << y << "次\n";
        cout << "若要繼續請輸入 1，結束請輸入 0\n";
        cin >> play;
    }

    return 0;
}
