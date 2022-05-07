/*******************************************************************
Group:Binghui Liu, Bernardo Rodriguez,Ivan Ruvalcaba, Kimberly Canchola
CSE5700 
lab1
 ********************************************************************/
#include <iostream>
#include <vector>
#include <string>
using namespace std;

bool check(string input){
    cout << "Input string:";
    //checking for only a or b input 
    for (int i = 0; i < input.length(); ++i)
    {
        if(input[i]!='a'){
            if(input[i]!='b'){
                cout << "Enter a string with only a's and b's" << endl;
                string sign;
                if(i+1 == 1){
                    sign = "st";
                }else if (i+1 == 2){
                    sign = "nd";
                }else if (i+1 == 3){
                    sign = "rd";
                }else{
                    sign = "th";
                }
                cout << "Error at the " << i+1 << sign << " character inputed" << endl;
                return false;
            }
        }
    };
    //printing out the string 
    for (int i = 0; i < input.length(); ++i)
    {
        cout << input[i] << " ";
    }
    cout << endl;
    int i = input.length()-3;

    //when the string end with abb it is aproved 
        if(input[i]=='a'){
            if(input[i+1]=='b'&&input[i+2]=='b')
            {
                return true;
            }
        }
    return false;
}

int main(){
    string input;
    while(true)
    {
        cout << "Enter the string: " ;
        cin >> input;
        if(check(input)){
            cout << "It is accepted" <<  endl;
        }else{
            cout << "It is not Accepted" << endl;
        }

        //repeat the program 
        char checks;
        cout << "Repeat? (Y or N) : ";
        cin >> checks;
        cout << endl;
        //want to end the program 
        if(checks != 'Y'){
            break;
        }
    }

    return 0;
} 