{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.17";
  src = 
	fetchurl {
		url = mirror://gnu/tar/tar-1.17.tar.bz2;
		sha256 = "14m49kya1swilivc2laycw3p3y3i1s3q0vkhwjan58aiv8fh5y8r";
	};
  patches = [./implausible.patch];
}
