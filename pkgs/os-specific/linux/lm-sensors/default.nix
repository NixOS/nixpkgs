{ stdenv, fetchurl, bison, flex, which, perl }:

let version = "3.4.0"; in

stdenv.mkDerivation rec {
  name = "lm-sensors-${version}";
  
  src = fetchurl {
    url = "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2";
    sha256 = "07q6811l4pp0f7pxr8bk3s97ippb84mx5qdg7v92s9hs10b90mz0";
  };

  buildInputs = [ bison flex which perl ];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out ETCDIR=$out/etc)
  '';

  meta = {
    homepage = http://www.lm-sensors.org/;
    description = "Tools for reading hardware sensors";
  };
}
