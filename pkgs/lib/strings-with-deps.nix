/*
Usage:

  You define you custom builder script by adding all build steps to a list.
  for example:
	builder = writeScript "fsg-4.4-builder"
		(textClosure [doUnpack addInputs preBuild doMake installPhase doForceShare]);

  a step is defined by noDepEntry, FullDepEntry or PackEntry.
  To ensure that prerequisite are met those are added before the task itself by
  textClosureDupList. Duplicated items are removed again.

  See trace/nixpkgs/trunk/pkgs/top-level/builder-defs.nix for some predefined build steps

*/

{stdenv, lib}:

with lib;

rec {

  /* !!! The interface of this function is kind of messed up, since
     it's way too overloaded and almost but not quite computes a
     topological sort of the depstrings. */

  textClosureList = predefined: arg:
    let
      f = done: todo:
        if todo == [] then {result = []; inherit done;}
        else
          let entry = head todo; in
          if isAttrs entry then
            let x = f done entry.deps;
                y = f x.done (tail todo);
            in { result = x.result ++ [entry.text] ++ y.result;
                 done = y.done;
               }
          else if hasAttr entry done then f done (tail todo)
          else f (done // listToAttrs [{name = entry; value = 1;}]) ([(builtins.getAttr entry predefined)] ++ tail todo);
    in (f {} arg).result;
    
  textClosureMap = f: predefined: names:
    concatStringsSep "\n" (map f (textClosureList predefined names));

  noDepEntry = text: {inherit text; deps = [];};
  fullDepEntry = text: deps: {inherit text deps;};
  packEntry = deps: {inherit deps; text="";};

  # Old names - don't use.
  FullDepEntry = fullDepEntry;
  PackEntry = packEntry;
  
}
