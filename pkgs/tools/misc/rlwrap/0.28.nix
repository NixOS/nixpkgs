args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = ftp://ftp.chg.ru/mirrors/ftp.freebsd.org/pub/FreeBSD/ports/distfiles/rlwrap-0.28.tar.gz;
			sha256 = "07jzhcqzb8jsmsscc28dk4md7swnhn3vyai5fpxwdj6a1kbn4y3p";
		};

		buildInputs = [readline ];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "rlwrap-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Readline wrapper for console programs.
";
		inherit src;
	};
}
