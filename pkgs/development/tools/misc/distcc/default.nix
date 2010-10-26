{ stdenv, fetchurl, popt, avahi, pkgconfig, python, gtk
, sysconfDir ? ""   # set this parameter to override the default value $out/etc
, static ? false
}:

let name    = "distcc";
    version = "3.1";
in

stdenv.mkDerivation {
  name = "${name}-${version}";
  src = fetchurl {
    url = "http://distcc.googlecode.com/files/${name}-${version}.tar.bz2";
    sha256 = "f55dbafd76bed3ce57e1bbcdab1329227808890d90f4c724fcd2d53f934ddd89";
  };

  buildInputs = [popt avahi pkgconfig python gtk];
  preConfigure =
  ''
    configureFlagsArray=( CFLAGS="-O2 -fno-strict-aliasing"
                          CXXFLAGS="-O2 -fno-strict-aliasing"
                          ${if sysconfDir == "" then "" else "--sysconfdir=${sysconfDir}"}
                          ${if static then "LDFLAGS=-static" else ""}
                          --with${if static == true || popt == null then "" else "out"}-included-popt
                          --with${if avahi != null then "" else "out"}-avahi
                          --with${if gtk != null then "" else "out"}-gtk
                          --without-gnome
                          --enable-rfc2553
                         )
    installFlags="sysconfdir=$out/etc";
  '';
  patches = [ ./20-minute-io-timeout.patch ];

  # The test suite fails because it uses hard-coded paths, i.e. /usr/bin/gcc.
  doCheck = false;

  meta = {
    description = "a fast, free distributed C/C++ compiler";
    homepage = "http://distcc.org";
    license = "GPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
