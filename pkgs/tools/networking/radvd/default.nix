{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "radvd-1.7";
  
  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.gz";
    sha256 = "04rlz5fhparridjm32wcq9h1s3vxyiac7d3l6cvfgrlxixikgrzq";
  };

  buildInputs = [ bison flex ];

  meta.homepage = http://www.litech.org/radvd/;
  meta.description = "IPv6 Router Advertisement Daemon";
}
