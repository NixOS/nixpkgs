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
		inherit (builtins)	
			head tail isList;
in
rec {

/*
	let  shelllib = rec {
		a= {
			text = "aaaa";
			deps = [b c];
		};
		b = {
			text = "b";
		};
		c = {
			text = "c";
			deps = [];
		};
	};
	in
	
	[textClosure [shelllib.a]
		textclosure shelllib.a];

	
*/
	
	textClosureDupList = arg: 
	(
		if isList arg then 
			textClosureDupList {text = ""; deps = arg;} 
		else
			(concatLists (map textClosureDupList arg.deps)) ++ [arg]
	);

	textClosureList = arg:
		(map	(x : x.text) 
			(uniqList {inputList = textClosureDupList arg;}));
	textClosure = arg: concatStringsSep "\n" (textClosureList arg);
	
	textClosureMap = f: arg: concatStringsSep "\n" (map f (textClosureList arg));

	noDepEntry = text : {inherit text;deps = [];};
	FullDepEntry = text : deps: {inherit text deps;};
	PackEntry = deps: {inherit deps; text="";};
}
