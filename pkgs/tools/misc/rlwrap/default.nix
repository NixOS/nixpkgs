args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = ftp://ftp.chg.ru/mirrors/ftp.freebsd.org/pub/FreeBSD/ports/distfiles/rlwrap-0.28.tar.gz;
			sha256 = "07jzhcqzb8jsmsscc28dk4md7swnhn3vyai5fpxwdj6a1kbn4y3p";
		};

		buildInputs = [readline ];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "rlwrap-0.28";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "Readline wrapper for console programs";
		inherit src;
	};
}
