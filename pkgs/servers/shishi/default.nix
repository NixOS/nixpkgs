{ fetchurl, stdenv, libtasn1, libgcrypt, gnutls }:

stdenv.mkDerivation rec {
  name = "shishi-1.0.0";

  src = fetchurl {
    url = "mirror://gnu/shishi/${name}.tar.gz";
    sha256 = "1j8jbfsdpwqqfv7938gy4b6kvdai3l2nk8267sv18rbp95k9j7ig";
  };

  buildInputs = [ libtasn1 libgcrypt gnutls ] ;

  doCheck = true;

  meta = {
    description = "GNU Shishi, free implementation of the Kerberos 5 network security system";

    longDescription =
      '' GNU Shishi is an implementation of the Kerberos 5 network
	 authentication system, as specified in RFC 4120.  Shishi can be
	 used to authenticate users in distributed systems.

	 Shishi contains a library (`libshishi') that can be used by
	 application developers to add support for Kerberos 5.  Shishi
	 contains a command line utility (1shishi') that is used by
	 users to acquire and manage tickets (and more).  The server
	 side, a Key Distribution Center, is implemented by `shishid'.
      '';

    homepage = http://www.gnu.org/software/shishi/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
