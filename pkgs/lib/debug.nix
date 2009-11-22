let lib = import ./default.nix;

inherit (builtins) trace attrNamesToStr isAttrs isFunction isList isInt
        isString isBool head substring attrNames;

inherit (lib) all id mapAttrsFlatten elem;

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
  traceXMLValMarked = str: if builtins ? trace then x: (builtins.trace ( str + builtins.toXML x) x) else x: x;
  
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
      else if isList x then "x is a list, first element is: ${showVal (head x)}"
      else if x == true then "x is boolean true"
      else if x == false then "x is boolean false"
      else if x == null then "x is null"
      else if isInt x then "x is an integer `${toString x}'"
      else if isString x then "x is a string `${substring 0 50 x}...'"
      else "x is probably a path `${substring 0 50 (toString x)}'";

  # trace the arguments passed to function and its result 
  # maybe rewrite these functions in a traceCallXml like style. Then one function is enough
  traceCall  = n : f : a : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a));
  traceCall2 = n : f : a : b : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b));
  traceCall3 = n : f : a : b : c : let t = n2 : x : traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b) (t "arg 3" c));

  traceValIfNot = c: x:
    if c x then true else trace (showVal x) false;

  /* Evaluate a set of tests.  A test is an attribute set {expr,
     expected}, denoting an expression and its expected result.  The
     result is a list of failed tests, each represented as {name,
     expected, actual}, denoting the attribute name of the failing
     test and its expected and actual results.  Used for regression
     testing of the functions in lib; see tests.nix for an example.
     Only tests having names starting with "test" are run.
     Add attr { tests = ["testName"]; } to run these test only
  */
  runTests = tests: lib.concatLists (lib.attrValues (lib.mapAttrs (name: test:
    let testsToRun = if tests ? tests then tests.tests else [];
    in if (substring 0 4 name == "test" ||  elem name testsToRun)
       && ((testsToRun == []) || elem name tests.tests)
       && (!lib.eqStrict test.expr test.expected)

      then [ { inherit name; expected = test.expected; result = test.expr; } ]
      else [] ) tests));
  


  # evaluate everything once so that errors will occur earlier
  # hacky: traverse attrs by adding a dummy
  # ignores functions (should this behavior change?) See strictf
  #
  # Note: This should be a primop! Something like seq of haskell would be nice to
  # have as well. It's used fore debugging only anyway
  strict = x :
    let
        traverse = x :
          if isString x then true
          else if isAttrs x then
            if x ? outPath then true
            else all id (mapAttrsFlatten (n: traverse) x)
          else if isList x then
            all id (map traverse x)
          else if isBool x then true
          else if isFunction x then true
          else if isInt x then true
          else if x == null then true
          else true; # a (store) path?
    in if (traverse x) then x else throw "else never reached";

  # example: (traceCallXml "myfun" id 3) will output something like
  # calling myfun arg 1: 3 result: 3
  # this forces deep evaluation of all arguments and the result!
  # note: if result doesn't evaluate you'll get no trace at all (FIXME)
  #       args should be printed in any case
  traceCallXml = a:
    if !isInt a then
      traceCallXml 1 "calling ${a}\n"
    else
      let nr = a;
      in (str: expr:
          if isFunction expr then
            (arg: 
              traceCallXml (builtins.add 1 nr) "${str}\n arg ${builtins.toString nr} is \n ${builtins.toXML (strict arg)}" (expr arg)
            )
          else 
            let r = strict expr;
            in builtins.trace "${str}\n result:\n${builtins.toXML r}" r
      );
}
