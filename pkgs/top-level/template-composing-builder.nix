args : with args; with builderDefs null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */

		buildInputs = [];
		configureFlags = [];
	}) args null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "${abort "Specify name"}-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[(abort "Specify phases - defined here or in builderDefs") doForceShare doPropagate]);
	meta = {
		description = "${abort "Write a description"}";
		inherit src;
	};
}
