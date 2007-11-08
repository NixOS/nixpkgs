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
