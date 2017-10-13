# CMSI 386 Fall 2017 Exam 1

Name: Eddie Bachoura

## Problem 1: Forcing Keyword Arguments

Suppose the boss demanded a function to compute the area of a rectangle. The boss says the function *MUST* have four parameters, `x1`, `y1`, `x2`, and `y2` where (`x1`, `y1`) is one of the corner points and (`x2`, `y2`) is the other corner point. But since our users can never remember what order the four parameters go in (Is it `x1`-`x2`-`y1`-`y2` or `x1`-`y1`-`x2`-`y2`?), we will make our function *REQUIRE* that the four arguments in the call be “named.” Note that I said required. The function is not supposed to work if the arguments are not named. In fact, it should be an error to make a call without “naming” the arguments.

a) Write the function in JavaScript:

```javascript
const areaOfRectangle = ({x1, y1, x2, y2}) => {
  return Math.abs(x2 - x1) * Math.abs(y2 - y1);
}
```

b) Write the function in Python:

```python
def area_of_rectangle(*, x1, y1 ,x2 ,y2):
    return abs(x2 - x1) * abs(y2 - y1)
```

c) Explain the most salient difference between the implementations in a single sentence.

> Javascript doesn't have keyword arguments the same way that Python3 does; instead javascript has pattern-matching, which is why the Python3 implementation takes in four ints, while the Javascript implementation takes in an object that has a value paired with each required key.


## Problem 2: Array of Functions

We want to make an array called `workers`, indexed from 0..10000 (inclusive), where each slot contains a function behaving as follows: `workers[i](x)` = `x - i`.

a) Define this array in JavaScript:

```javascript
let workers = [];
for (let i = 0; i < 10001; i++) {
  workers.push(x => x - i)
}
```

b) Define this list in Python:

```python
workers = []
for i in list(range(10001)):
    workers.append(lambda x: x - i)
```

c) Explain the most salient difference between the implementations in a single sentence.

> For the Python3 implementation, when you call the function, it doesn't work as expected because the variable i is defined within the scope of the array and therefore every single function within workers, referenced the same `i = 10000`, while in Javascript, by using `let`, we are able to define a new `i` for every single function, because each function has its own scope, which an `i` defined within it.


## Problem 3: Generators, From Scratch

We have studied generators in JavaScript and Python. To make an arithmetic sequence generator in JavaScript, we would write:

```javascript
function* arithmeticSequenceGenerator(start, delta) {
   let value = start;
   while (true) {
       yield value;
       value += delta;
   }
}
```

while in Python we have:

```python
def arithmetic_sequence_generator(start, delta):
   value = start;
   while True:
       yield value
       value += delta
```

a) We can write generators from first principles using closures. Show me you know how to do this. Write `arithmeticSequenceGenerator` in JavaScript, without using a generator function:

```javascript
const arithmeticSequenceGenerator = (start, delta) => {
  const generator = (() => {
    let value = start;
    return () => {
      return value += delta;
    }
  });

  return generator();
}
```

b) Write `arithmetic_sequence_generator` in Python as a regular, non-generator, function:

```python
def arithmetic_sequence_generator(start, delta):
    value = start
    def advance():
        nonlocal value
        current = value
        value += delta
        return current
    return advance
```

c) One of the freshmen suggested closures were overkill and said to just make a class whose constructor took in the starting value and the delta, and whose `next` method did the work. Why is this worse than the closure approach? (Answer super briefly, under ten words if possible.)

> With a function you call it once and it is instantiated and you can keep calling that variable, while classes you would need also know the name of the advance function after you have instantiated the class.


## Problem 4: Rests and Spreads (Unpacking and packing)

We want a function that takes an arbitrary number of arguments and returns their average (also known as the mean).

a) Write the function in JavaScript:

```javascript
const average = (...x) => {
  return x.reduce((sum, value) => sum + value, 0) / x.length;
}
```

b) Write the function in Python:

```python
def average(*x):
    return sum(list(x)) / len(x)
```

c) To call the function in JavaScript, one would write something like `mean(4.5, 2, 11, -7)`. But what if we had a JavaScript array? How could we use the function we wrote to compute the mean of the elements in an array?

```javascript
const average = (...x) => {
  let z = x.reduce((a, b) => a.concat(b), [])
  return z.reduce((sum, value) => sum + value, 0) / z.length;
}
```

d) Now show the same function invocaton in Python (that is, to take the average of elements in a Python list):

```python
average(*[1,2,3],*[3,4,5])
```


## Problem 5: Mapping and Filtering, or Not?

Suppose we were given two lists, one of given names, and one of surnames. We want a function to produce a list of full names, in the form "`SURNAME, Givenname`" (that's right, you need to uppercase the surname and capitalize the given name, and separate them with a comma and single space), where the difference in lengths between the two names is less than four. For example, if the surname list was `['Xu', 'Narkhirunkanok', 'gomez']` and the given name list was `['kIMberly', 'LIA']` then your function should produce `['XU, Lia', 'GOMEZ, Kimberly', 'GOMEZ, Lia']`. All other name combinations have a length differential that is too high.

a) Write the function in JavaScript using the proper higher-order functions for this task:

```javascript
let firstNames = ["eddie","Eileen","dog","cAT"]
let lastNames = ["Bachoura","CHOE","Spike","mEOW"]

result = [];
[firstNames,lastNames].forEach((x, index))

a.map(x => [x, x**3])

incomplete
```

b) Write the function in Python *using a list comprehension*:

```python

```


## Problem 6: Currying
I really wish that scrolled far enough to see this problem...

Okay here's something weird. We're going to write a function called `poly` such that

 * `poly(3)` returns a representation of the polynomial 3
 * `poly(3)(5)` returns a representation of the polynomial 5x + 3
 * `poly(3)(5)(-2)` returns a representation of the polynomial -2x^2 + 5x + 3
 * `poly(3)(5)(-2)(0)(6)` returns a representation of the polynomial 6x^4 -2x^2 + 5x + 3

Note that if a polynomial is ever applied to a number, the polynomial is "extended" to the next degree with a new coefficient. This is weird enough but now we are also going to give the function an attribute (in Python) or method (in Java) called `at` to evaluate the polynomial at a given value. So, for example:

 * `poly(3)(5).at(2)` returns 5(2) + 3 = 13
 * `poly(3)(5)(-2).at(10)` returns -2(10)^2 + 5(10) + 3 = -200 + 50 + 3 = -147

a) Implement `poly` in JavaScript. (Hint: you will need a function definition and an assignment statement for the method).

```javascript

```

b) Implement `poly` in Python. (Hint: you will need a function definition and an assignment statement for the attribute).

```python

```

c) What design aspects of Python and JavaScript (that say, do not exist in Java) allowed this to work?

> (ANSWER HERE)


## Problem 7: Implicit Context

Here is a JavaScript function:

```javascript
function filterBetween(...myList) {
    return myList.filter((x) => this.min < x && x <= this.max);
}
```

The expression `filterBetween.call({min: 2, max: 8}, 9, 8, 3, -1)` properly returns `[8, 3]`.

a) Rewrite the expression to use `apply` instead of `call`:

```javascript

```

b) Rewrite the expression to use `bind` instead of `call`:

```javascript

```

c) One of the freshmen tried `const hello = {min: 2, max: 8, tween: filterBetween}; hello.tween(9, 8, 3, -1)`. Does that work? Why or why not?

> (ANSWER HERE)

d) If we had written `filterBetween = (...myList) => myList.filter((x) => this.min < x && x <= this.max)`, what would happen when evaluating `filterBetween.call({min: 2, max: 8}, 9, 8, 3, -1)`? Why, specifically?

> (ANSWER HERE)


## Problem 8: Class Extensions (Not Inheritance)

So let's say we have access to a JavaScript class that someone else wrote. It's a class for a box that is either (1) empty, or (2) contains a value. The original author used `undefined` to represent an empty box. We're stuck with that. Anyway, the class is already complete and it looks like this:

```javascript
class Box {
  constructor(value) { this.value = value; }
  isEmpty() { return this.value === undefined; }
  getOrElse(backup) { return this.value === undefined ? backup : this.value; }
}
```

Then we decide we want to add a method to update the value in a box. We can do this in JavaScript! We have prototypes! We just have to do this:

```javascript
Box.prototype.set = function (value) { this.value = value; }
```

Now assuming a similar Python class was already written, like so:

```python
class Box:
  def __init__(self, value=None): self.value = value
  def is_empty(self): return self.value is None
  def get_or_else(self, backup): return backup if self.value is None else self.value
```

Show how to add the new `set` method to the existing `Box` class:

```python

```
