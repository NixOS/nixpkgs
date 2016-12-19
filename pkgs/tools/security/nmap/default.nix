{ stdenv, fetchurl, libpcap, pkgconfig, openssl
, graphicalSupport ? false
, gtk2 ? null
, libX11 ? null
, withPython ? false # required for the `ndiff` binary
, python2 ? null
}:

assert withPython -> python2 != null;

with stdenv.lib;

let

  # Zenmap (the graphical program) also requires Python,
  # so automatically enable pythonSupport if graphicalSupport is requested.
  pythonSupport = withPython || graphicalSupport;

  pythonEnv = python2.withPackages(ps: with ps; []
    ++ optionals graphicalSupport [ pycairo pygobject2 pygtk pysqlite ]
  );

in stdenv.mkDerivation rec {
  name = "nmap${optionalString graphicalSupport "-graphical"}-${version}";
  version = "7.31";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "0hiqb28950kn4bjsmw0ksfyss7j2qdmgrj3xsjf7073pq01lx7yb";
  };

  patches = ./zenmap.patch;

  configureFlags = []
    ++ optional (!pythonSupport) "--without-ndiff"
    ++ optional (!graphicalSupport) "--without-zenmap"
    ;

  buildInputs = [ libpcap pkgconfig openssl ]
    ++ optional pythonSupport pythonEnv
    ++ optionals graphicalSupport [ gtk2 libX11 ]
    ;

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ mornfall thoughtpolice fpletz ];
  };
}
