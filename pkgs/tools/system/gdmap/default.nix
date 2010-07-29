args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
		    url = http://downloads.sourceforge.net/gdmap/gdmap-0.8.1.tar.gz;
		    sha256 = "0nr8l88cg19zj585hczj8v73yh21k7j13xivhlzl8jdk0j0cj052";
		};

		buildInputs = [gtk pkgconfig libxml2 intltool gettext];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "gdmap-0.8.1";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "Recursive rectangle map of disk usage";
		inherit src;
	};
}
