args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = ftp://ftp.debian.org/debian/pool/main/l/ltrace/ltrace_0.5.orig.tar.gz;
		sha256 = "1nbjcnizc0w3p41g7hqf1qiany8qk4xs9g4zrlq4fpxdykdwla3v";
	};

		buildInputs = [elfutils ];
		configureFlags = [];
		goSrcDir = "
			cd ltrace-*;
		";
	} null; /* null is a terminator for sumArgs */
let
	preConfigure = FullDepEntry ("
		sed -e 's@-o root -g root@@' -i Makefile.in;
	") [doUnpack minInit];
in
stdenv.mkDerivation rec {
	name = "ltrace-0.5";
	builder = writeScript (name + "-builder")
		(textClosure [preConfigure doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Library call tracer.
";
	};
}
