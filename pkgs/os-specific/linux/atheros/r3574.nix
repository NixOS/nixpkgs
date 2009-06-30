args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		  fetchurl {
		    url = http://snapshots.madwifi.org/madwifi-trunk/madwifi-trunk-r3574-20080426.tar.gz;
		    sha256 = "1awr8jxrh6nvrsnyaydafkz7yarax3h4xphjcx6gmwsfbyb2mj7q";
		  };

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let
postInstall = fullDepEntry (''
	ln -s $out/usr/local/bin $out/bin
'') [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doMakeInstall postInstall
			doForceShare doPropagate]);
	meta = {
		description = "Atheros WiFi driver";
		inherit src;
	};
}
