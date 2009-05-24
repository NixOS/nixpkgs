let lib = import ./default.nix;

inherit (builtins) trace attrNamesToStr isAttrs isFunction isList head substring attrNames;

in

rec {


  # Wrapper aroung the primop `addErrorContext', which shouldn't used
  # directly.  It evaluates and returns `val', but if an evaluation
  # error occurs, the text in `msg' is added to the error context
  # (stack trace) printed by Nix.
  addErrorContext =
    if builtins ? addErrorContext
    then builtins.addErrorContext
    else msg: val: val;

  addErrorContextToAttrs = lib.mapAttrs (a : v : lib.addErrorContext "while evaluating ${a}" v);

  
  traceVal = if builtins ? trace then x: (builtins.trace x x) else x: x;
  traceXMLVal = if builtins ? trace then x: (builtins.trace (builtins.toXML x) x) else x: x;

  
  # this can help debug your code as well - designed to not produce thousands of lines
  traceShowVal = x : trace (showVal x) x;
  traceShowValMarked = str: x: trace (str + showVal x) x;
  attrNamesToStr = a : lib.concatStringsSep "; " (map (x : "${x}=") (attrNames a));
  showVal = x :
      if isAttrs x then
          if x ? outPath then "x is a derivation, name ${if x ? name then x.name else "<no name>"}, { ${attrNamesToStr x} }"
          else "x is attr set { ${attrNamesToStr x} }"
      else if isFunction x then "x is a function"
      else if x == [] then "x is an empty list"
      else if isList x then "x is a list, first item is : ${showVal (head x)}"
      else if x == true then "x is boolean true"
      else if x == false then "x is boolean false"
      else if x == null then "x is null"
      else "x is probably a string starting, starting characters: ${substring 0 50 x}..";
  # trace the arguments passed to function and its result 
  traceCall  = n : f : a : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a));
  traceCall2 = n : f : a : b : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b));
  traceCall3 = n : f : a : b : c : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b) (t "arg 3" c));


  /* Evaluate a set of tests.  A test is an attribute set {expr,
     expected}, denoting an expression and its expected result.  The
     result is a list of failed tests, each represented as {name,
     expected, actual}, denoting the attribute name of the failing
     test and its expected and actual results.  Used for regression
     testing of the functions in lib; see tests.nix for an example.
  */
  runTests = tests: lib.concatLists (lib.attrValues (lib.mapAttrs (name: test:
    if ! lib.eqStrict test.expr test.expected
      then [ { inherit name; expected = test.expected; result = test.expr; } ]
      else [] ) tests));
  
}
