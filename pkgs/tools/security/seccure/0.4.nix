args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function ((rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://point-at-infinity.org/seccure/seccure-0.4.tar.gz;
			sha256 = "33d690a7034ee349bce4911a8b7c73e6e3cd13a140f429e9e628d5cd5a3bb955";
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
