args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "${abort "Specify name"}-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[(abort "Specify phases - defined here or in builderDefs") doForceShare doPropagate]);
	meta = {
		description = "
		${abort "Write a description"}
";
	};
}
