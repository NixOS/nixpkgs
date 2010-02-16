{ fetchurl, stdenv, libgcrypt, libevent, libidn, gnutls
, libxml2, zlib, texinfo, cppunit, xz }:

let version = "0.9.2"; in
  stdenv.mkDerivation rec {
    name = "myserver-${version}";

    src = fetchurl {
      url = "mirror://gnu/myserver/${version}/${name}.tar.xz";
      sha256 = "110001ssyrvmvqrkxbz09a5m945ahh478v1l7aq31gh1l9j0cf6n";
    };

    patches = [ ./tests-in-chroot.patch ];

    buildInputs = [ libgcrypt libevent libidn gnutls libxml2 zlib texinfo xz ]
      ++ stdenv.lib.optional doCheck cppunit;

    doCheck = true;

    meta = {
      description = "GNU MyServer, a powerful and easy to configure web server";

      longDescription = ''
        GNU MyServer is a powerful and easy to configure web server.  Its
        multi-threaded architecture makes it extremely scalable and usable in
        large scale sites as well as in small networks, it has a lot of
        built-in features.  Share your files in minutes!
      '';

      homepage = http://www.gnu.org/software/myserver/;

      license = "GPLv3+";

      maintainers = [ stdenv.lib.maintainers.ludo ];

      # libevent fails to build on Cygwin and Guile has troubles on Darwin.
      platforms = stdenv.lib.platforms.gnu;
    };
  }
