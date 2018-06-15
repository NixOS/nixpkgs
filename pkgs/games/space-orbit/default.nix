{ stdenv, fetchurl
, libGLU_combined, libXi, libXt, libXext, libX11, libXmu, freeglut
}:

stdenv.mkDerivation rec {
  name = "space-orbit-${version}";
  version = "1.01";
  patchversion = "9";

  buildInputs = [ libGLU_combined libXi libXt libXext libX11 libXmu freeglut ];

  src = fetchurl {
    url = "mirror://debian/pool/main/s/space-orbit/space-orbit_${version}.orig.tar.gz";
    sha256 = "1kx69f9jqnfzwjh47cl1df8p8hn3bnp6bznxnb6c4wx32ijn5gri";
  };

  patches = [
    (fetchurl {
       url = "mirror://debian/pool/main/s/space-orbit/space-orbit_${version}-${patchversion}.diff.gz";
       sha256 = "1v3s97day6fhv08l2rn81waiprhi1lfyjjsj55axfh6n6zqfn1w2";
     })
  ];

  preBuild = ''
    cd src
    sed -e 's@/usr/share/games/orbit/@'$out'/dump/@g' -i *.c
    sed -e '/DIR=/d; s/-lesd//; s/-DESD//;' -i Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r .. $out/dump
    cat >$out/bin/space-orbit <<EOF
#! ${stdenv.shell}
exec $out/dump/orbit "\$@"
EOF
    chmod a+x $out/bin/space-orbit
  '';

  meta = with stdenv.lib; {
    description = "A space combat simulator";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
