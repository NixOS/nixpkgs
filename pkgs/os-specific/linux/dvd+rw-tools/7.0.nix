args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.0.tar.gz;
			sha256 = "08hljn2vfn794dfrfpp3m245dbpb6nhk40igfpqm6wg9qimc9zy9";
		};

		buildInputs = [cdrkit m4];
		configureFlags = [];
		makeFlags = [" prefix=\$out "];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
	preBuild = FullDepEntry ("
		sed -e '1i#define INT_MAX __INT_MAX__' -i *.c *.cpp
		sed -e 's@/usr/local@'\$out'@g' -i Makefile.m4 Makefile
	") [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "dvd+rw-tools-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [preBuild addInputs (doDump "0") doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	DVD+RW tools.
";
		inherit src;
	};
}
