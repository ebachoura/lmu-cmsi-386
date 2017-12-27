#include <iostream>
#include <cassert>

using namespace std;

struct Say {
private:
    string message;
public:
    Say(string s): message(s) {}
    Say(): message() {};

    Say operator()(string s) {
      string spacer = ((message == "")? "" : " ");
      return Say(message + spacer + s);
    }
    string operator()() {
        return message;
    }
};

Say f; // object declaration

int main() {
  assert(f() == "");
  assert(f("Hello,")("World!")() == "Hello, World!");
  assert(f("Hello,")("")("World!")() == "Hello,  World!");
  assert(f("Hello,")("")("")("")("")("")("World!")() == "Hello,      World!");  
  assert(f("My")("name")("is")("Eileen!")() == "My name is Eileen!");
  cout << "All test passed!" << '\n';
}
