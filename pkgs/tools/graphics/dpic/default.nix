{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2019.08.30";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "059m53cppw67hwygm7l03ciaxbnaldx63bqdhx1vzbx3kiwz8iw2";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  makeFlags = "CC=${stdenv.cc.outPath}/bin/cc";

  installPhase = ''
    mkdir -p $out/bin
    cp -fv dpic $out/bin
  '';

  meta = {
    homepage = https://ece.uwaterloo.ca/~aplevich/dpic/;
    description = "An implementation of the pic little language for creating drawings";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.aespinosa ];
    platforms = stdenv.lib.platforms.all;
  };
}

