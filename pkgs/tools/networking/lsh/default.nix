{stdenv, fetchurl, gperf, guile, gmp, zlib, liboop, gnum4, pam}:

stdenv.mkDerivation {
  name = "lsh-2.0.4";
  src = fetchurl {
    url = http://www.lysator.liu.se/~nisse/archive/lsh-2.0.4.tar.gz;
    sha256 = "614b9d63e13ad3e162c82b6405d1f67713fc622a8bc11337e72949d613713091";
  };

  buildInputs = [gperf guile gmp zlib liboop gnum4 pam];

  meta = {
    description = "GNU lsh, a GPL'd implementation of the SSH protocol.";
    homepage = http://www.lysator.liu.se/~nisse/lsh/;
    license = "GPL";
  };
}
