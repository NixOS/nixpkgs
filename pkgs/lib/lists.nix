# General list operations.
with {
  inherit (import ./trivial.nix) deepSeq;
};

rec {
  inherit (builtins) head tail length isList add sub lessThan;


  # Create a list consisting of a single element.  `singleton x' is
  # sometimes more convenient with respect to indentation than `[x]'
  # when x spans multiple lines.
  singleton = x: [x];


  # "Fold" a binary function `op' between successive elements of
  # `list' with `nul' as the starting value, i.e., `fold op nul [x_1
  # x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
  # Haskell's foldr).
  fold =
    if builtins ? elemAt
    then op: nul: list:
      let
        len = length list;
        fold' = n:
          if n == len
          then nul
          else op (builtins.elemAt list n) (fold' (add n 1));
      in fold' 0
    else op: nul:
      let fold' = list:
        if list == []
        then nul
        else op (head list) (fold' (tail list));
      in fold';

    
  # Left fold: `fold op nul [x_1 x_2 ... x_n] == op (... (op (op nul
  # x_1) x_2) ... x_n)'.
  foldl =
    if builtins ? elemAt
    then op: nul: list:
      let
        len = length list;
        foldl' = n:
          if n == minus1
          then nul
          else op (foldl' (sub n 1)) (builtins.elemAt list n);
      in foldl' (sub (length list) 1)
    else op:
      let foldl' = nul: list:
        if list == []
        then nul
        else foldl' (op nul (head list)) (tail list);
      in foldl';

  minus1 = sub 0 1;


  # map with index: `imap (i: v: "${v}-${toString i}") ["a" "b"] ==
  # ["a-1" "b-2"]'
  imap = f: list:
    zipListsWith f (range 1 (length list)) list;

    
  # Concatenate a list of lists.
  concatLists = builtins.concatLists or (fold (x: y: x ++ y) []);


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
  filter =
    builtins.filter or
    (pred: list:
      fold (x: y: if pred x then [x] ++ y else y) [] list);

    
  # Remove elements equal to 'e' from a list.  Useful for buildInputs.
  remove = e: filter (x: x != e);

  
  # Given two lists, removes all elements of the first list from the second list
  removeList = l: filter (x: elem x l);


  # Return true if `list' has an element `x'.
  elem =
    builtins.elem or
    (x: list: fold (a: bs: x == a || bs) false list);


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
  any = pred: fold (x: y: if pred x then true else y) false;


  # Return true iff function `pred' returns true for all elements of
  # `list'.
  all = pred: fold (x: y: if pred x then y else false) true;


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
      ++ zipListsWith f (tail fst) (tail snd)
    else [];

  zipLists = zipListsWith (fst: snd: { inherit fst snd; });

  
  # Reverse the order of the elements of a list.
  reverseList = l:
    let reverse_ = accu: l:
      if l == [] then accu
      else reverse_ ([(head l)] ++ accu) (tail l);
    in reverse_ [] l;

    
  # Sort a list based on a comparator function which compares two
  # elements and returns true if the first argument is strictly below
  # the second argument.  The returned list is sorted in an increasing
  # order.  The implementation does a quick-sort.
  sort = strictLess: list:
    let
      # This implementation only has one element list on the left hand
      # side of the concatenation operator.
      qs = l: concat:
        if l == [] then concat
        else if length l == 1 then l ++ concat
        else let
          part = partition (strictLess (head l)) (tail l);
        in
          qs part.wrong ([(head l)] ++ qs part.right concat);
    in
      qs list [];


  # Return the first (at most) N elements of a list.
  take = count: list:
    if list == [] || count == 0 then []
    else [ (head list) ] ++ take (builtins.sub count 1) (tail list);

    
  # Remove the first (at most) N elements of a list.
  drop = count: list:
    if count == 0 then list
    else drop (builtins.sub count 1) (tail list);

    
  last = list:
    assert list != [];
    let loop = l: if tail l == [] then head l else loop (tail l); in
    loop list;


  # Zip two lists together.
  zipTwoLists = xs: ys:
    if xs != [] && ys != [] then
      [ {first = head xs; second = head ys;} ]
      ++ zipTwoLists (tail xs) (tail ys)
    else [];

  deepSeqList = xs: y: if any (x: deepSeq x false) xs then y else y;
}
