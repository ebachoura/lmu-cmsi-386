#include <cassert>
#include <iostream>

using namespace std;

template <typename T>
class Queue {

  struct Node {
    T data;
    Node* next;
  };

  int size = 0;
  Node* head = nullptr;
  Node* tail = nullptr;

public:
  ~Queue() {
    while (head != nullptr) {
      dequeue();
    }
  }

  Queue() = default;

  // Allow move semantics
  Queue(Queue&& s): size(s.size), head(s.head), tail(s.tail) {
    s.head = nullptr;
    s.tail = nullptr;
    s.size = 0;
  }

  Queue& operator=(Queue&& s) {
    if (&s != this) {
      size = s.size;
      head = s.head;
      tail = s.tail;

      s.head = nullptr;
      s.tail = nullptr;
      s.size = 0;
    }
    return *this;
  }

  // Prohibit copy semantics
  Queue(const Queue& q) = delete;
  Queue& operator=(const Queue& q) = delete;

  int get_size() {
    return size;
  }

  T get_head() {
    return head->data;
  }

  T get_tail() {
    return tail->data;
  }

  void enqueue(T x) {
    if(size == 0) {
      tail = new Node {x};
      head = tail;
    } else {
      tail->next = new Node {x};
      tail = tail->next;
    }
    size++;
  }

  T dequeue() {
    if (size == 0) {
        throw underflow_error("Cannot dequeue from an empty queue.");
    }
    T dequeuedData = head->data;
    if (size == 1) {
        delete head;
        head = nullptr;
        tail = nullptr;
        size--;
        return dequeuedData;
    }
    Node* oldHead = head;
    head = head->next;
    delete oldHead;
    size--;
    return dequeuedData;
  }
};
