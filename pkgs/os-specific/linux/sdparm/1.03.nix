args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
      url = http://freshmeat.net/redir/sdparm/66844/url_bz2/sdparm-1.03.tar.bz2;
      sha256 = "2066af4d55c60bba366b34a29e02f37264e8e1f0efc232d65beba5e317c20819";
		};

		buildInputs = [];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "sdparm-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "Utility for setting parameters of SCSI devices";
		inherit src;
	};
}
