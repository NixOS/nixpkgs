{ stdenv, fetchurl, libpcap, pkgconfig, openssl
, graphicalSupport ? false
, libX11 ? null
, gtk ? null
, python ? null
, pygtk ? null
, makeWrapper ? null
, pygobject ? null
, pycairo ? null
, pysqlite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "nmap${optionalString graphicalSupport "-graphical"}-${version}";
  version = "6.40";

  src = fetchurl {
    url = "http://nmap.org/dist/${name}.tar.bz2";
    sha256 = "491f77d8b3fb3bb38ba4e3850011fe6fb43bbe197f9382b88cb59fa4e8f7a401";
  };

  patches = optional graphicalSupport ./zenmap.patch;

  postInstall = optionalString graphicalSupport ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
  '';

  buildInputs = [ libpcap pkgconfig openssl ]
    ++ optionals graphicalSupport [
      libX11 gtk python pygtk makeWrapper pysqlite pygobject pycairo
    ];

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ mornfall thoughtpolice ];
  };
}
