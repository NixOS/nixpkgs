{ stdenv, fetchurl, libpcap, pkgconfig, openssl
, graphicalSupport ? false
, libX11 ? null
, gtk2 ? null
, withPython ? false # required for the `ndiff` binary
, python2Packages ? null
, makeWrapper ? null
}:

assert withPython -> python2Packages != null;

with stdenv.lib;

let

  # Zenmap (the graphical program) also requires Python,
  # so automatically enable pythonSupport if graphicalSupport is requested.
  pythonSupport = withPython || graphicalSupport;

in stdenv.mkDerivation rec {
  name = "nmap${optionalString graphicalSupport "-graphical"}-${version}";
  version = "7.70";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "063fg8adx23l4irrh5kn57hsmi1xvjkar4vm4k6g94ppan4hcyw4";
  };

  patches = ./zenmap.patch;

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = []
    ++ optional (!pythonSupport) "--without-ndiff"
    ++ optional (!graphicalSupport) "--without-zenmap"
    ;

  postInstall = optionalString pythonSupport ''
      wrapProgram $out/bin/ndiff --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH"
  '' + optionalString graphicalSupport ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath $pygtk)/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath $pygobject)/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath $pycairo)/gtk-2.0
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with python2Packages; [ libpcap openssl ]
    ++ optionals pythonSupport [ makeWrapper python ]
    ++ optionals graphicalSupport [
      libX11 gtk2 pygtk pysqlite pygobject2 pycairo
    ];

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice fpletz ];
  };
}
