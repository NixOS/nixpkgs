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
args:

with args;
with lib;

let
  inherit (builtins) head tail isList isAttrs;
in

rec {

  textClosureDupList = arg:
    if isList arg then 
      textClosureDupList {text = ""; deps = arg;} 
    else
      concatLists (map textClosureDupList arg.deps) ++ [arg];

  textClosureDupListOverridable = predefined: arg:
    if isList arg then 
      textClosureDupListOverridable predefined {text = ""; deps = arg;} 
    else if isAttrs arg then
      concatLists (map (textClosureDupListOverridable predefined) arg.deps) ++ [arg]
    else
      textClosureDupListOverridable predefined (getAttr [arg] [] predefined);

  textClosureListOverridable = predefined: arg:
    map (x: x.text) (uniqList {inputList = textClosureDupListOverridable predefined arg;});
      
  textClosureOverridable = predefined: arg: concatStringsSep "\n" (textClosureListOverridable predefined arg);
  
  textClosureMapOveridable = f: predefined: arg:
    concatStringsSep "\n" (map f (textClosureListOverridable predefined arg));

  noDepEntry = text: {inherit text; deps = [];};
  fullDepEntry = text: deps: {inherit text deps;};
  packEntry = deps: {inherit deps; text="";};

  # Old names - don't use.
  FullDepEntry = fullDepEntry;
  PackEntry = packEntry;
  
}
