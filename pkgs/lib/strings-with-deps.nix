args: 
	with args;
	with lib;
	let 
		inherit (builtins)	
			head tail isList;
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
			(if (arg ? deps) then 
				map textClosureDupList arg.deps 
			else []) 
		++ [arg]
	);

	textClosureList = arg: uniqList (textClosureDupList arg);
	textClosure = arg: concatStringsSep "
" (textClosureList arg);
	
	noDepEntry = text : {inherit text;};
	FullDepEntry = text : deps: {inherit text args;};
}
