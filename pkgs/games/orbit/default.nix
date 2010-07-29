args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
			sha256 = "1kx69f9jqnfzwjh47cl1df8p8hn3bnp6bznxnb6c4wx32ijn5gri";
			url = http://ftp.de.debian.org/debian/pool/main/s/space-orbit/space-orbit_1.01.orig.tar.gz;
		};

		buildInputs = [mesa libXi libXt libXext libX11 libXmu freeglut esound];
		configureFlags = [];
		debianPatch = 
		fetchurl {
			url = http://ftp.de.debian.org/debian/pool/main/s/space-orbit/space-orbit_1.01-9.diff.gz;
			sha256 = "1v3s97day6fhv08l2rn81waiprhi1lfyjjsj55axfh6n6zqfn1w2";
		};
		customBuild = fullDepEntry (''
			gunzip < ${debianPatch} | patch -Np1
                        cd src
			sed -e 's@/usr/share/games/orbit/@'$out'/dump/@g' -i *.c
                        sed -e '/DIR=/d' -i Makefile 
                        make 
                        ensureDir $out/bin
                        cp -r .. $out/dump
                        cat >$out/bin/space-orbit <<EOF
#! /bin/sh
$out/dump/orbit "\$@"
EOF
                        chmod a+x $out/bin/space-orbit
		'') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "space-orbit-1.01";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[ customBuild doForceShare doPropagate]);
	meta = {
		description = "Orbit space flight simulator";
		inherit src;
	};
}

