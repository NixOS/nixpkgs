{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2019.11.30";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "0rgd31mdbaqbm9rz49872s17n25n5ajxcn61xailz3f0kzr4f3dg";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  makeFlags = [ "CC=${stdenv.cc.outPath}/bin/cc" ];

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

