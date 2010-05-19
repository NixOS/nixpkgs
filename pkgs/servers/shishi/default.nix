{ fetchurl, stdenv, libtasn1, libgcrypt, gnutls }:

stdenv.mkDerivation rec {
  name = "shishi-0.0.43";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/shishi/${name}.tar.gz";
    sha256 = "17hj4lklvprws6r5bhavi43yj3bz8sv554gcqvvsjrsq8w3qjxm0";
  };

  buildInputs = [ libtasn1 libgcrypt gnutls ] ;

  doCheck = true;

  meta = {
    description = "GNU Shishi, free implementation of the Kerberos 5 network security system";

    longDescription =
      '' GNU Shishi is an implementation of the Kerberos 5 network 
         authentication system, as specified in RFC 4120. Shishi can be 
         used to authenticate users in distributed systems.

         Shishi contains a library ('libshishi') that can be used by
         application developers to add support for Kerberos 5.  Shishi
         contains a command line utility ('shishi') that is used by
         users to acquire and manage tickets (and more).  The server
         side, a Key Distribution Center, is implemented by 'shishid'.
       '';

    homepage = http://www.gnu.org/software/shishi/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
