args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://snapshots.madwifi.org/madwifi-ng/madwifi-ng-r3122-20080109.tar.gz;
			sha256 = "188258c6q96n8lb57c0cqsvxp47psninirdax13w4yd07v1rymwd";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Atheros WiFi driver.
";
	};
}
