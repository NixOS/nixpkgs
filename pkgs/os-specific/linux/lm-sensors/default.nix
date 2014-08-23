{ stdenv, fetchurl, bison, flex, which, perl }:

let version = "3.3.5"; in

stdenv.mkDerivation rec {
  name = "lm-sensors-${version}";
  
  src = fetchurl {
    url = "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2";
    sha256 = "1ksgrynxgrq590nb2fwxrl1gwzisjkqlyg3ljfd1al0ibrk6mbjx";
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
