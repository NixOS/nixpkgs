{stdenv, fetchurl, gperf, guile, gmp, zlib, liboop, gnum4, pam}:

stdenv.mkDerivation {
  name = "lsh-2.0.4";
  src = fetchurl {
    url = http://www.lysator.liu.se/~nisse/archive/lsh-2.0.4.tar.gz;
    sha256 = "614b9d63e13ad3e162c82b6405d1f67713fc622a8bc11337e72949d613713091";
  };

  patches = [ ./pam-service-name.patch ];

  buildInputs = [gperf guile gmp zlib liboop gnum4 pam];

  meta = {
    description = "GNU lsh, a GPL'd implementation of the SSH protocol";

    longDescription = ''
      lsh is a free implementation (in the GNU sense) of the ssh
      version 2 protocol, currently being standardised by the IETF
      SECSH working group.
    '';
    
    homepage = http://www.lysator.liu.se/~nisse/lsh/;
    license = "GPLv2+";
  };
}
