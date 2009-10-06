# General list operations.

rec {
  inherit (builtins) head tail isList;


  # Create a list consisting of a single element.  `singleton x' is
  # sometimes more convenient with respect to indentation than `[x]'
  # when x spans multiple lines.
  singleton = x: [x];
  

  # "Fold" a binary function `op' between successive elements of
  # `list' with `nul' as the starting value, i.e., `fold op nul [x_1
  # x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
  # Haskell's foldr).
  fold = op: nul: list:
    if list == []
    then nul
    else op (head list) (fold op nul (tail list));

    
  # Left fold: `fold op nul [x_1 x_2 ... x_n] == op (... (op (op nul
  # x_1) x_2) ... x_n)'.
  foldl = op: nul: list:
    if list == []
    then nul
    else foldl op (op nul (head list)) (tail list);


  # Concatenate a list of lists.
  concatLists = fold (x: y: x ++ y) [];


  # Map and concatenate the result.
  concatMap = f: list: concatLists (map f list);


  # Flatten the argument into a single list; that is, nested lists are
  # spliced into the top-level lists.  E.g., `flatten [1 [2 [3] 4] 5]
  # == [1 2 3 4 5]' and `flatten 1 == [1]'.
  flatten = x:
    if isList x
    then fold (x: y: (flatten x) ++ y) [] x
    else [x];

    
  # Filter a list using a predicate; that is, return a list containing
  # every element from `list' for which `pred' returns true.
  filter = pred: list:
    fold (x: y: if pred x then [x] ++ y else y) [] list;


  # Return true if `list' has an element `x':
  elem = x: list: fold (a: bs: x == a || bs) false list;


  # Find the sole element in the list matching the specified
  # predicate, returns `default' if no such element exists, or
  # `multiple' if there are multiple matching elements.
  findSingle = pred: default: multiple: list:
    let found = filter pred list;
    in if found == [] then default
       else if tail found != [] then multiple
       else head found;


  # Find the first element in the list matching the specified
  # predicate or returns `default' if no such element exists.
  findFirst = pred: default: list:
    let found = filter pred list;
    in if found == [] then default else head found;
       

  # Return true iff function `pred' returns true for at least element
  # of `list'.
  any = pred: list:
    if list == [] then false
    else if pred (head list) then true
    else any pred (tail list);


  # Return true iff function `pred' returns true for all elements of
  # `list'.
  all = pred: list:
    if list == [] then true
    else if pred (head list) then all pred (tail list)
    else false;


  # Return true if each element of a list is equal, false otherwise.
  eqLists = xs: ys:
    if xs == [] && ys == [] then true
    else if xs == [] || ys == [] then false
    else head xs == head ys && eqLists (tail xs) (tail ys);

    
  # Return a singleton list or an empty list, depending on a boolean
  # value.  Useful when building lists with optional elements
  # (e.g. `++ optional (system == "i686-linux") flashplayer').
  optional = cond: elem: if cond then [elem] else [];


  # Return a list or an empty list, dependening on a boolean value.
  optionals = cond: elems: if cond then elems else [];


  # If argument is a list, return it; else, wrap it in a singleton
  # list.  If you're using this, you should almost certainly
  # reconsider if there isn't a more "well-typed" approach.
  toList = x: if builtins.isList x then x else [x];

    
  # Return a list of integers from `first' up to and including `last'.
  range = first: last:
    if builtins.lessThan last first
    then []
    else [first] ++ range (builtins.add first 1) last;

    
  # Partition the elements of a list in two lists, `right' and
  # `wrong', depending on the evaluation of a predicate.
  partition = pred:
    fold (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; };


  zipListsWith = f: fst: snd:
    if fst != [] && snd != [] then
      [ (f (head fst) (head snd)) ]
      ++ zipLists (tail fst) (tail snd)
    else [];

  zipLists = zipListsWith (fst: snd: { inherit fst snd; });

  # invert the order of the elements of a list.
  reverseList = l:
    let reverse_ = accu: l:
      if l == [] then accu
      else reverse_ ([(head l)] ++ accu) (tail l);
    in reverse_ [] l;
}
