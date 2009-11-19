args: with args; 
	let localDefs = builderDefs.passthru.function {
  		buildInputs =[mesa wxGTK libX11 xproto];
		  src = 
			fetchurl {
				url = http://www.piettes.com/fallingsandgame/fsg-src-4.4.tar.gz;
				sha256 = "1756y01rkvd3f1pkj88jqh83fqcfl2fy0c48mcq53pjzln9ycv8c";
			};
	};
	in with localDefs;
let 
	preBuild = fullDepEntry "
		sed -e '
		s@currentProbIndex != 100@0@;
		' -i MainFrame.cpp;
	" [minInit];

  installPhase = fullDepEntry "
		ensureDir \$out/bin \$out/libexec;
		cp sand \$out/libexec;
		echo -e '#! /bin/sh\nLC_ALL=C '\$out'/libexec/sand \"$@\"' >\$out/bin/fsg;
		chmod a+x \$out/bin/fsg;
	" [minInit defEnsureDir];
in
stdenv.mkDerivation {
  name = "fsg-4.4";
	builder = writeScript "fsg-4.4-builder"
		(textClosure localDefs [doUnpack addInputs preBuild doMake installPhase doForceShare]);

  meta = {
    description = "Falling Sand Game - a cellular automata engine tuned towards the likes of Falling Sand";
    inherit src;
  };
}
