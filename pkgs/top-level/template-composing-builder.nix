args : with args;
	with builderDefs {
		src = /* put a fetchurl here */

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	with stringsWithDeps;
stdenv.mkDerivation rec {
	name = "${abort "Specify name"}";
	builder = writeScript (name + "-builder")
		(textClosure [(abort "Specify phases - defined here or in builderDefs") doForceShare doPropagate]);
	meta = {
		description = "
		${abort "Write a description"}
";
	};
}
