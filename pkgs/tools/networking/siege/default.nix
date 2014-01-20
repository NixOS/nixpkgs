{ stdenv, fetchurl }:
let
  version = "3.0.2";
  baseName = "siege";
in stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  src = fetchurl {
    url = "http://www.joedog.org/pub/siege/${name}.tar.gz";
    sha256 = "0b86rvcrjxy6h9w32bhpcm1gwmn223mf9f30dfsnaw51w90kn716";
  };
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";
}
