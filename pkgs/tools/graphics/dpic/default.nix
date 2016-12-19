{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dpic-${version}";
  version = "2016.01.12";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${name}.tar.gz";
    sha256 = "0iwwf8shgm8n4drz8mndvk7jga93yy8plnyby3lgk8376g5ps6cz";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  makeFlags = "CC=${stdenv.cc.outPath}/bin/cc";

  installPhase = ''
    mkdir -p $out/bin
    cp -fv dpic $out/bin
  '';

  meta = {
    homepage = "https://ece.uwaterloo.ca/~aplevich/dpic/";
    description = "An implementation of the pic little language for creating drawings";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.aespinosa ];
    platforms = stdenv.lib.platforms.all;
  };
}

