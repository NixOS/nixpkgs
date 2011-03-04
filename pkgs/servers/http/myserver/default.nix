{ fetchurl, stdenv, libgcrypt, libevent, libidn, gnutls
, libxml2, zlib, guile, texinfo, cppunit, xz, psmisc }:

let version = "0.10"; in
  stdenv.mkDerivation (rec {
    name = "myserver-${version}";

    src = fetchurl {
      url = "mirror://gnu/myserver/${version}/${name}.tar.xz";
      sha256 = "0w8njgka54if8ycd9cyxgmqa0ivv7r0rka7gda3x2rfr2z4nxvpb";
    };

    patches = [ ./disable-dns-lookup-in-chroot.patch ];

    buildInputs =
      [ libgcrypt libevent libidn gnutls libxml2 zlib guile texinfo xz ]
      ++ stdenv.lib.optional doCheck cppunit;

    makeFlags = [ "V=1" ];

    doCheck = true;

    enableParallelBuilding = true;

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

  //

  # On GNU/Linux the `test_suite' process sometimes stays around, so
  # forcefully terminate it.
  (if stdenv.isLinux
   then { postCheck = "${psmisc}/bin/killall test_suite || true"; }
   else { }))
