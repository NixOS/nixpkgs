args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://sg.torque.net/sg/p/sdparm-1.02.tgz;
			sha256 = "13acyg6r65gypdprjhfkmvaykgfcj1riwpnycpvv9znzgq9fxsiv";
		};

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "sdparm-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	SCSI parameters utility.
";
		inherit src;
	};
}
