#include <string>
#include <string.h>
#include <vector>
#include <iostream>
#include <map>
#include <cstdlib>
#include "LR.h"

using namespace std;

    void LR0Item::Push(LRProduction *p)
    {
        productions.push_back(p);
    }

    int LR0Item::Size()
    {
        return int(productions.size());
    }

    bool LR0Item::Contains(string production)
    {
        for (auto it = productions.begin(); it != productions.end(); it++)
        {
            string existing = string(&(*it)->lhs, 1) + "->" + (*it)->rhs;
            if (strcmp(production.c_str(), existing.c_str()) == 0)
                return true;
        }
        return false;
    }


    LRProduction* LR0Item::operator[](const int index)
    {
        return productions[index];
    }