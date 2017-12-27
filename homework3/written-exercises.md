# Homework 3

1. (5 pts) Given the C++ declaration:

   ```c++
   struct {
     int n;
     char c;
   } A[10][10];
   ```

   On your machine, find the address of `A[0][0]` and `A[3][7]`. Explain why these values are what you found them to be.

   > The C++ declaration creates the object A, which is a 10x10 two dimensional array with members of type struct. Each struct is 8 bytes, therefore, `sizeof(A)` is 8 * 100 = 800 bytes. C++ arrays are stored in row-major order. This means that the order that the structs are stored in memory are as follows:
   >
   > (0,0) (0,1) (0,2) … (0, 9) (1,0) (1, 1) … (9,9)
   >
   > `A[0][0]` is at memory address `0x7ffebcf35770` when we ran this example, but it would be different each time you ran it and on each device you ran it on.
   >
   >  `A[3][7]` is the 37th struct from the beginning, therefore it is located 37 * 8 = 296 (or, 0x128) bytes  from `A[0][0]`. Therefore it is at memory address `0x7ffebcf35770 + 0x128 = 0x7ffebcf35898`.

   ​

2. (5 pts) Explain the meaning of the following C++ declarations:

   ```c++
   // double *a[n];
   // a is an array of size n of pointers to doubles.

   // Example:
   const int n = 3;
   double *a[n];
   for (int i = 0; i < n; i++) {
     a[i] = new double((double)i);
   }
   for (int i = 0; i < n; i++) {
     assert(*a[i] == (double)i);
   }
   ```

   ```c++
   // double (*b)[n];
   // b is a pointer to an array of size n of doubles.

   // Example:
   const int n = 3;
   double doubleArr[n] = {0.0, 1.0, 2.0};
   double (*b)[n];
   b = &doubleArr;
   for (int i = 0; i < n; i++) {
       assert((*b)[i] == (double)i);
   }
   ```

   ```c++
   // double (*c[n])();
   // c is an array of size n of pointers to functions with return type double.

   // Example:
   #include <iostream>
   using namespace std;

   double f() {
       return (double)(rand() % 100);
   }

   int main() {
       const int n = 3;
       double (*c[n])();

       for (int i = 0; i < n; i ++){
           c[i] = &f;
       }
       
       cout << (*c[0])() << endl; // random doubles
       cout << (*c[1])() << endl;
       cout << (*c[2])() << endl;
   }
   ```

   ```c++
   // double (*d())[n];
   // d is a function which returns a pointer to an array of size n of doubles

   // Example:
   #include <cassert>
   #include <iostream>
   #include <array>

   using namespace std;
   const int n = 3;

   double a[3] = {2, 5, 9};
   double (*p)[3] = &a;
   typedef double (*pointerToArrayOfDoubles)[3];

   pointerToArrayOfDoubles d() {
       return p;
   }

   int main() {
       assert((*d())[0] == 2);
       assert((*d())[1] == 5);
       assert((*d())[2] == 9);
   }
   ```

3. (5 pts) Consider the following declaration in C++:

   ```c++
   double (*f(double (*)(double, double[]), double)) (double, ...);
   ```

   Describe rigorously, in English, the type of f.

   > `typedef double *G(double, double[])`
   >
   > **Note**: G, when pointed to, is a function with parameters `double` and `double[]` and return type `double`.
   >
   > `f`, when pointed to, is a function with parameters `G` and `double`, and return type `function`. This function has parameters `double`, and a variable arguments list (which can be accessed using macros such as stdarg.h) and return type `double`.

   ​

4. (5 pts) What happens when we “redefine” a field in a C++ subclass? For example, suppose we have:

   ```c++
   class Base {
   public:
     int a;
     std::string b;
   };

   class Derived: Base {
   public:
     float c;
     int b;
   };
   ```

   Does the representation of a Derived object contain one b field or two? If two, are both accessible, or only one? Under what circumstances? Tell the story of how things are.

   > Every instance of Derived contains the subobject, Base. The new b added in the Derived class doesn't override Base class' b, it just *hides* it.

   ```c++
   using namespace std;

   int main() {
     class Base {
       public:
       int a = 100;
       std::string b = "default";
     };
     class Derived: public Base {
     	public:
       float c = 300.0;
       int b = 200;
     };
       
     Derived* d = new Derived;
     cout << d->a << '\n'; // 100
     cout << d->b << '\n'; // 200
     cout << ((Base*)d)->b << "\n"; // default
   }
   ```

   > You would access `int b` via `d->b` and `std::string b` via `((Base*)d)->b` (type cast the pointer d, which is type "pointer to Derived", to type "pointer to Base")


5. (5 pts) What does the following C++ program output?

   ```c++
   #include <iostream>
   int x = 2;
   void f() { x = 7; std::cout << x << '\n'; }
   void g() { int x = 5; f(); std::cout << x << '\n'; }
   int main() {
     g();
     std::cout << x << '\n';
   }
   ```

   > 2
   > 5
   > 2

   Verify that the answer you obtained is the same that would be inferred from apply the rules of static scoping. If C++ used dynamic scoping, what would the output have been?

   >If we are using dynamic scoping, we first look for a local definition of a variable. If it isn't found, we look up the calling stack for a definition. Thus, the output would have been:
   >
   >5
   >
   >5
   >
   >2

6. (5 pts) Suppose you were asked to write a function to scramble (shuffle) a given array, in a mutable fashion. Give the function signature for a shuffle function for (a) a raw array, and (b) a std::array.

   >  (a)
   >
   >  ```
   >  template <typename T>
   >  void shuffleRawArray(T* a, int length)
   >  ```
   >
   >  (b) 
   >
   >  ```
   >  template<typename T, std::size_t SIZE>
   >  void shuffleStdArray(std::array<T, SIZE>& a) 
   >  ```

   >```c++
   >#include <iostream>
   >#include <array>
   >#include <algorithm>
   >#include <chrono>
   >
   >using namespace std;
   >
   >template <typename T>
   >void shuffleRawArray(T* a, int length) {
   >    random_shuffle(a, a + length);
   >}
   >
   >template<typename T, std::size_t SIZE>
   >void shuffleStdArray(std::array<T, SIZE>& a) { 
   >    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
   >    shuffle(a.begin(), a.end(), default_random_engine(seed));
   >}
   >
   >void printIt(int* a, int length) {
   >    cout << "[ ";
   >    for (int i = 0; i < length; i++) {
   >        cout << a[i] << ' ';
   >    };
   >    cout << "]\n";
   >}
   >
   >int main() {
   >    int a[] = {10, 3, 2, 5, 6, 8, 3, 2, 1, 99, 88, 100, -3};
   >    printIt(a, 13);
   >    shuffleRawArray(a, 13);
   >    printIt(a, 13);
   >
   >    array<int, 3> b = {1, 2, 3};
   >    cout<< b[0] << " " << b[1] << " " << b[2] << endl;
   >    shuffleStdArray(b);
   >    cout<< b[0] << " " << b[1] << " " << b[2] << endl;
   >}
   >```

   ​

7. (15 pts) Write a C++ application, in the file

   wordcount.cpp

   that reads standard input and displays a word count table to standard output. Normalize and lowercase the file text. Sort the output by number of occurrences descending. For example, if the input file is:

   ```
   The tests, my lord,have failed! FAILED
       have   the   tests,   they   have.
   ```

   then your program should output:

   ```
   have 3
   failed 2
   tests 2
   the 2
   lord 1
   my 1
   they 1
   ```

   “Words” are made up of Unicode letters only. Every other character is ignored. Use whatever wonderful functions you can find from the standard library. (In fact, one of the learning objectives for this problem is that you gain experience by looking through the standard library.)

   **NOTE**: Unicode processing in C++ frequently requires external libraries like Boost or ICU, and integrating these requires time and effort. Therefore you should *first* solve this problem taking words to be ASCII letters only to maximize partial credit in case you run out of time. If you run out of time trying to integrate a library and end up with no solution, you will get a zero. A working solution with ASCII words only will receive a score of 13/15. Please work to maximize your score.

   ​

8. (15 pts) Implement the famous `say` function from the previous two homeworks, in C++. Put the function, together with a `main` function loaded with `assert` calls to validate that it works, in the file *say.cpp*.

   ​

9. (30 pts) Write, in the file *queue.h*, an implementation of a generic singly-linked queue (template) class, implemented using nodes and pointers. The queue object should have three fields: (1) a pointer to the head node, (2) a pointer to the tail node, and (3) the current size of the queue (its number of elements). You may use smart pointers or raw pointers (whichever you would enjoy practicing with more). **Support move semantics but prohibit copying**. Expose public methods `enqueue`, `dequeue`, and `get_size`, and make sure queues can be written to ostreams with the `<<` operator. Throw the standard exception `underflow_error`when trying to dequeue from an empty queue.

   ​

10. (10 pts) Write a little program in *queue_test.cpp* that runs a fairly exhaustive suite of tests on your queue class. It’s fine to just use raw `assert`s. See if your tests can show that moving is indeed possible. In the comments, answer the question: Can you test that copying and assignment are prohibited in a unit test? Why or why not?