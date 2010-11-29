{ stdenv, fetchurl, openssl, fuse, boost, rlog }:

stdenv.mkDerivation {
  name = "encfs-1.6.1";

  src = fetchurl {
    url = "http://encfs.googlecode.com/files/encfs-1.6-1.tgz";
    sha256 = "0k50ic5nyibb9giif9dqm6sj20q0yzri3drg78m788z17xp060mw";
  };

  buildInputs = [ boost fuse openssl rlog ];

  configureFlags = "--with-boost-serialization=boost_wserialization --with-boost-filesystem=boost_filesystem";

  meta = {
    homepage = http://www.arg0.net/encfs;
    description = "EncFS provides an encrypted filesystem in user-space via FUSE";
  };
}
