args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function ((rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://freshmeat.net/redir/seccure/65485/url_tgz/seccure-0.3.tar.gz;
			sha256 = "0isah96p35yxm86dklmgmdkvpflqi2aj4k344jp57chrhg5av74d";
		};

		buildInputs = [libgcrypt];
		configureFlags = [];
		doPatch = FullDepEntry (''
			sed -e s@/usr/@$out/@g -i Makefile
			ensureDir $out/bin $out/share/man/man1
		'') ["minInit" "doUnpack" "defEnsureDir"];
	}) // args);
	in with localDefs;
stdenv.mkDerivation rec {
	name = "seccure-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			["doPatch" doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "Zero-configuration elliptic curve cryptography utility";
		inherit src;
	};
}
