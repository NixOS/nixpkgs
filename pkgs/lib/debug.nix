let lib = import ./default.nix; in

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

  debugVal = if builtins ? trace then x: (builtins.trace x x) else x: x;
  debugXMLVal = if builtins ? trace then x: (builtins.trace (builtins.toXML x) x) else x: x;

  # this can help debug your code as well - designed to not produce thousands of lines
  traceWhatis = x : __trace (whatis x) x;
  traceMarked = str: x: __trace (str + (whatis x)) x;
  attrNamesToStr = a : lib.concatStringsSep "; " (map (x : "${x}=") (__attrNames a));
  whatis = x :
      if (__isAttrs x) then
          if (x ? outPath) then "x is a derivation, name ${if x ? name then x.name else "<no name>"}, { ${attrNamesToStr x} }"
          else "x is attr set { ${attrNamesToStr x} }"
      else if (__isFunction x) then "x is a function"
      else if (x == []) then "x is an empty list"
      else if (__isList x) then "x is a list, first item is : ${whatis (__head x)}"
      else if (x == true) then "x is boolean true"
      else if (x == false) then "x is boolean false"
      else if (x == null) then "x is null"
      else "x is probably a string starting, starting characters: ${__substring 0 50 x}..";
  # trace the arguments passed to function and its result 
  traceCall  = n : f : a : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a));
  traceCall2 = n : f : a : b : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b));
  traceCall3 = n : f : a : b : c : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b) (t "arg 3" c));

}
