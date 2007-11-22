args : with args; with builderDefs (args // {
		src = /* put a fetchurl here */
		(abort "Specify source");
		useConfig = true;
		reqsList = [
			["true" ]
			["false"]
		];
		/* List consisiting of an even number of strings; "key" "value" */
		configFlags = [
		];
	}) null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "${(abort "Specify name")}"+version;
	builder = writeScript (name + "-builder")
		(textClosure [(abort "Check phases") doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	${(abort "Specify description")}
";
	};
}
