{ lib, fetchurl, stdenv, libgcrypt, libevent, libidn, gnutls
, libxml2, zlib, guile, texinfo, cppunit, killall }:

let version = "0.11"; in

stdenv.mkDerivation rec {
  name = "myserver-${version}";

  src = fetchurl {
    url = "mirror://gnu/myserver/${version}/${name}.tar.xz";
    sha256 = "02y3vv4hxpy5h710y79s8ipzshhc370gbz1wm85x0lnq5nqxj2ax";
  };

  patches =
    [ ./disable-dns-lookup-in-chroot.patch ];

  buildInputs = [
    libgcrypt libevent libidn gnutls libxml2 zlib guile texinfo
  ];

  checkInputs = [ cppunit ];

  makeFlags = [ "V=1" ];

  doCheck = true;

  enableParallelBuilding = true;

  # On GNU/Linux the `test_suite' process sometimes stays around, so
  # forcefully terminate it.
  postCheck = "${killall}/bin/killall test_suite || true";

  meta = {
    description = "GNU MyServer, a powerful and easy to configure web server";

    longDescription = ''
      GNU MyServer is a powerful and easy to configure web server.  Its
      multi-threaded architecture makes it extremely scalable and usable in
      large scale sites as well as in small networks, it has a lot of
      built-in features.  Share your files in minutes!
    '';

    homepage = https://www.gnu.org/software/myserver/;

    license = lib.licenses.gpl3Plus;

    # libevent fails to build on Cygwin and Guile has troubles on Darwin.
    platforms = lib.platforms.gnu ++ lib.platforms.linux;

    broken = true; # needs patch for gets()
  };
}
