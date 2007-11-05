args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://ftp.gnome.org/pub/gnome/sources/intltool/0.36/intltool-0.36.2.tar.bz2;
		sha256 = "0cfblqz3k5s4rsw6rx9f5v3izsrmrs96293rb7bd02vijbah9gxj";
	};

		buildInputs = [perl perlXMLParser];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	with stringsWithDeps;
stdenv.mkDerivation rec {
	name = "intltool-0.36.2";
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Internalization tool for XML.
";
	};
}
