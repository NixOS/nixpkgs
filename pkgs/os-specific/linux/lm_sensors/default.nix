{ stdenv, fetchurl, bison, flex, which, perl }:

let version = "3.3.1"; in

stdenv.mkDerivation rec {
  name = "lm-sensors-3.3.1";
  
  src = fetchurl {
    url = "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2";
    sha256 = "13v2gszagmx8hwjyzh2k47rdpc2kyg9zky3kdqhdbgzp8lwpik6g";
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
