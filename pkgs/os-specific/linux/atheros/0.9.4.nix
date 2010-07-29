{ stdenv, fetchurl, builderDefs, kernel }:
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
		  url = http://downloads.sourceforge.net/madwifi/madwifi-0.9.4.tar.gz;
		  sha256 = "06jd5b8rfw7rmiva6jgmrb7n26g5plcg9marbnnmg68gbcqbr3xh";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
	};
	in with localDefs;
let 
postInstall = fullDepEntry (''
	ln -s $out/usr/local/bin $out/bin
'') [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "atheros-0.9.4";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doMakeInstall 
			postInstall doForceShare doPropagate]);
	meta = {
		description = "Atheros WiFi driver";
		inherit src;
	};
}
