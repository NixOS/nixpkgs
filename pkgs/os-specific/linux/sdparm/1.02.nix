args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://sg.torque.net/sg/p/sdparm-1.02.tgz;
			sha256 = "13acyg6r65gypdprjhfkmvaykgfcj1riwpnycpvv9znzgq9fxsiv";
		};

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "sdparm-"+version;
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	SCSI parameters utility.
";
	};
}
