# CMSI 386 Fall 2017 Exam 1

Name: ANSWER KEY

## Problem 1: Forcing Keyword Arguments

Suppose the boss demanded a function to compute the area of a rectangle. The boss says the function *MUST* have four parameters, `x1`, `y1`, `x2`, and `y2` where (`x1`, `y1`) is one of the corner points and (`x2`, `y2`) is the other corner point. But since our users can never remember what order the four parameters go in (Is it `x1`-`x2`-`y1`-`y2` or `x1`-`y1`-`x2`-`y2`?), we will make our function *REQUIRE* that the four arguments in the call be “named.” Note that I said required. The function is not supposed to work if the arguments are not named. In fact, it should be an error to make a call without “naming” the arguments.

a) Write the function in JavaScript:

```javascript
// This is the simplest full credit answer. For "error" it is okay to
// just return NaN unless all four values are present. This is an exam;
// I am not picky. If you read the problem as requiring an error be thrown
// then you must check that each of the four values are !== undefined.
// You CANNOT just say if (x1 && x2 && y1 && y2) because that rejects 0.
function area({x1, y1, x2, y2}) {
  return Math.abs(x2 - x1) * Math.abs(y2 - y1);
}
```

b) Write the function in Python:

```python
# One way to force the arguments to be named is accept kwargs only. If a
# named argument is missing we just get a KeyError. Good enough for an
# exam! No need to do our own error checking. For homework you'd have to
# do a bit better, though.
def area(**kwargs):
    return abs(kwargs['x2']-kwargs['x1']) * abs(kwargs['y2']-kwargs['y1'])
```

```python
# There is a better way. We did not cover it in class. But here it is. Anything
# after the * placeholder is a required keyword parameter, just what we want.
def area(*, x1, y1, x2, y2):
    return abs(x2-x1) * abs(y2-y1)
```

c) Explain the most salient difference between the implementations in a single sentence.

> JavaScript uses destructuring and Python uses kwargs


## Problem 2: Array of Functions

We want to make an array called `workers`, indexed from 0..10000 (inclusive), where each slot contains a function behaving as follows: `workers[i](x)` = `x - i`.

a) Define this array in JavaScript:

```javascript
const workers = [];
for (let i = 0; i <= 10000; i += 1) {
  workers.push(x => x - i);
}
```

b) Define this list in Python:

```python
workers = []
for i in range(10001):
    def f(i):
        return lambda x: x - i
    workers.append(f(i))
```

c) Explain the most salient difference between the implementations in a single sentence.

> JavaScript's `let` (as well as `forEach`) will use a different `i` each time, but Python's list comprehension or for-loop would have only a single `i`, necessating that we pass in the current `i` into an inner function with its own `i`.


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
function arithmeticSequenceGenerator(start, delta) {
  let nextValue = start;
  let value;
  return { next: () => {
    [value, nextValue] = [nextValue, nextValue + delta];
    return value;
  }};
}
```

b) Write `arithmetic_sequence_generator` in Python as a regular, non-generator, function:

```python
# This problem was too tricky and deep for this exam perhaps, but it's pretty cool!
def arithmetic_sequence_generator(start, delta):
    next_value = start
    class C:
        def __next__(self):
            nonlocal next_value
            value = next_value
            next_value += delta
            return value
    return C()
```

c) One of the freshmen suggested closures were overkill and said to just make a class whose constructor took in the starting value and the delta, and whose `next` method did the work. Why is this worse than the closure approach? (Answer super briefly, under ten words if possible.)

> There would be no way to hide the generate state!


## Problem 4: Rests and Spreads (Unpacking and packing)

We want a function that takes an arbitrary number of arguments and returns their average (also known as the mean).

a) Write the function in JavaScript:

```javascript
function mean(...numbers) {
  let sum = 0;
  for (let x of numbers) {
    sum += x;
  }
  return sum / numbers.length;
}
```

```javascript
// Here's another way
function mean(...numbers) {
  return numbers.reduce((x, y) => x + y, 0) / numbers.length;
}
```



b) Write the function in Python:

```python
def mean(*numbers):
    return sum(numbers) / len(numbers)
```

c) To call the function in JavaScript, one would write something like `mean(4.5, 2, 11, -7)`. But what if we had a JavaScript array? How could we use the function we wrote to compute the mean of the elements in an array?

```javascript
mean(...numbers)
```

d) Now show the same function invocaton in Python (that is, to take the average of elements in a Python list):

```python
mean(*numbers)
```


## Problem 5: Mapping and Filtering, or Not?

Suppose we were given two lists, one of given names, and one of surnames. We want a function to produce a list of full names, in the form "`SURNAME, Givenname`" (that's right, you need to uppercase the surname and capitalize the given name, and separate them with a comma and single space), where the difference in lengths between the two names is less than four. For example, if the surname list was `['Xu', 'Narkhirunkanok', 'gomez']` and the given name list was `['kIMberly', 'LIA']` then your function should produce `['XU, Lia', 'GOMEZ, Kimberly', 'GOMEZ, Lia']`. All other name combinations have a length differential that is too high.

a) Write the function in JavaScript using the proper higher-order functions for this task:

```javascript
// Well here it is without higher order functions first:
function sortOfBalancedNames(names, surnames) {
  const fullNames = [];
  for (let last of surnames) {
    for (let first of names) {
      if (Math.abs(last.length - first.length) < 4) {
        fullNames.push(`${last.toUpperCase()}, ${first[0].toUpperCase()}${first.slice(1).toLowerCase()}`);
      }
    }
  }
  return fullNames;
}
// At this point I'd be like this is good enough. I don't have time to use map and filter.
```

```javascript
// There is a data-flowy approach with HOFs everywhere. Not sure if it's popular
// tho. I did NOT expect you to come up with this during the exam. However, you
// should try to understand it. I doubt that this is efficient. I don't even
// think it is that pretty. Meh.
function sortOfBalancedNames(names, surnames) {
  return surnames.map(last => names.map(first => [last, first])).
    reduce((a, b) => [...a, ...b], []).
    filter(([last, first]) => Math.abs(last.length - first.length) < 4).
    map(([last, first]) => `${last.toUpperCase()}, ${first[0].toUpperCase()}${first.slice(1).toLowerCase()}`)
}
```

b) Write the function in Python *using a list comprehension*:

```python
def sort_of_balanced_names(names, surnames):
    return [last.upper() + ', ' + first.capitalize()
            for last in surnames
            for first in names
            if abs(len(last) - len(first)) < 4]
```


## Problem 6: Currying

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
function poly(c) {
  const coefficients = [];
  function inner(c) {coefficients.push(c); return inner;}
  const result = inner(c);
  result.at = x => coefficients.map((c, i) => c*x**i).reduce((x, y) => x + y, 0);
  return result;
}
```

b) Implement `poly` in Python. (Hint: you will need a function definition and an assignment statement for the attribute).

```python
def poly(c):
  coefficients = []
  def inner(c):
      coefficients.append(c)
      return inner
  result = inner(c)
  result.at = lambda x: sum(c*x**i for (i,c) in enumerate(coefficients))
  return result
```

c) What design aspects of Python and JavaScript (that say, do not exist in Java) allowed this to work?

> The fact that functions can have arbitrary properties/attributes!


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
filterBetween.apply({min: 2, max: 8}, [9, 8, 3, -1])
```

b) Rewrite the expression to use `bind` instead of `call`:

```javascript
filterBetween.bind({min: 2, max: 8})(9, 8, 3, -1)
```

c) One of the freshmen tried `const hello = {min: 2, max: 8, tween: filterBetween}; hello.tween(9, 8, 3, -1)`. Does that work? Why or why not?

> Yes, `hello` is the receiver of the method call and it has `min` and `max` properties, as desired.

d) If we had written `filterBetween = (...myList) => myList.filter((x) => this.min < x && x <= this.max)`, what would happen when evaluating `filterBetween.call({min: 2, max: 8}, 9, 8, 3, -1)`? Why, specifically?

> You get the list filtered between the values of the global variables `min` and `max`. Arrow functions don't have their own `this`! So the value of `this` from the outer context is used.


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
def set_a_value(self, value):
    self.value = value

Box.set = set_a_value
```
