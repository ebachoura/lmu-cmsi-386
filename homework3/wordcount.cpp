#include <iostream>
#include <fstream>
#include <map>
#include <iterator>
#include <set>

using namespace std;

int main(int argc, char** argv) {
  char* filepath = argv[1];
  ifstream reader(filepath);

  if(!reader){
    cout << "Error opening file" << endl;
    return -1;
  }

  map<string, int> dictionary = {};
  char letter;
  string word;

  for(int i = 0; ! reader.eof(); i++){
    reader.get(letter);
    if (isalpha(letter)) {
      word += tolower(letter, locale());
    } else {
      if (word != "") {
        map<string, int>::iterator it = dictionary.find(word);
        if (it == dictionary.end()) {
          dictionary.insert(pair<string, int>(word, 1));
        } else {
          (it->second)++;
        }
        word = "";
      };
    }
  }
  reader.close();

  typedef function<bool(pair<string, int>, pair<string, int>)> Comparator;
  Comparator compFunctor = [](pair<string, int> elem1 ,pair<string, int> elem2) {
    return elem1.second >= elem2.second;
  };
  set<pair<string, int>, Comparator> setOfWords(dictionary.begin(), dictionary.end(), compFunctor);

  for (pair<string, int> element : setOfWords) {
    cout << element.first << " " << element.second << endl;
  }
};
