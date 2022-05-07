#pragma once
#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

class LRProduction
{
public:
    char lhs;
    string rhs;

    LRProduction() {}
    LRProduction(char _lhs, string _rhs) : lhs(_lhs), rhs(_rhs) {}
};

class LR0Item
{

    private:
        vector <LRProduction* > productions;

    public:
        map<int, char> gotos;
        LR0Item() {}
        ~LR0Item() {}
        void Push(LRProduction *p);
        int Size();
        bool Contains(string production);
        LRProduction* operator[](const int index);
};