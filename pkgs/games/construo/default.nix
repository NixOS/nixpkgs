{ stdenv, fetchurl, builderDefs, libX11, zlib, xproto, mesa ? null, freeglut ? null }:

	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://savannah.nongnu.org/download/construo/construo-0.2.2.tar.gz;
			sha256 = "0c661rjasax4ykw77dgqj39jhb4qi48m0bhhdy42vd5a4rfdrcck";
		};

		buildInputs = [ libX11 zlib xproto ]
                  ++ stdenv.lib.optional (mesa != null) mesa
                  ++ stdenv.lib.optional (freeglut != null) freeglut;
		preConfigure = builderDefs.stringsWithDeps.fullDepEntry (''
		  sed -e 's/math[.]h/cmath/' -i vector.cxx
		  sed -e 's/games/bin/' -i Makefile.in
		  sed -e '1i\#include <stdlib.h>' -i construo_main.cxx -i command_line.cxx -i config.hxx
		  sed -e '1i\#include <string.h>' -i command_line.cxx -i lisp_reader.cxx -i unix_system.cxx \
		      -i world.cxx construo_main.cxx
		'') ["doUnpack" "minInit"];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "construo-0.2.2";
	builder = writeScript (name + "-builder")
		(textClosure localDefs ["preConfigure" "doConfigure" "doMakeInstall" "doForceShare" "doPropagate"]);
	meta = {
		description = "Construo masses and springs simulation";
	};
}
