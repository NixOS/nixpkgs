{ stdenv, fetchurl, openssl, fuse, boost, rlog }:

stdenv.mkDerivation {
  name = "encfs-1.7.4";

  src = fetchurl {
    url = "http://encfs.googlecode.com/files/encfs-1.7.4.tgz";
    sha256 = "1a3h47f4h0qdc0bf3vic1i8wrdw5nkx22mml4wsvmmrd9zqg0bi8";
  };

  buildInputs = [ boost fuse openssl rlog ];

  configureFlags = "--with-boost-serialization=boost_wserialization --with-boost-filesystem=boost_filesystem";

  meta = {
    homepage = http://www.arg0.net/encfs;
    description = "Provides an encrypted filesystem in user-space via FUSE";
  };
}
