args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://ftp.acc.umu.se/pub/gnome/sources/intltool/0.40/intltool-0.40.5.tar.bz2;
		sha256 = "011lg8s437kd2bysihi4wm6ph6pv1f9f1lwz4dzbwpif0kl6isr9";
	};

		propagatedBuildInputs = [perl perlXMLParser];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "intltool-0.40.5";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [minInit addInputs doUnpack 
			(doDump "1") doConfigure doMakeInstall 
			doPropagate doForceShare]);
	inherit propagatedBuildInputs;
	meta = {
		description = "
	Internalization tool for XML.
";
		inherit src;
	};
}
