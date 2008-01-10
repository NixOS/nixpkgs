args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://downloads.sourceforge.net/madwifi/madwifi-0.9.3.3.tar.bz2;
		sha256 = "1dq56dx81wfhpgipbrl3gk2is3g1xvysx2pl6vxyj0dhslkcnf3y";
	};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
	} null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	builder = writeScript (name + "-builder")
		(textClosure [doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Atheros WiFi driver.
";
	};
}
