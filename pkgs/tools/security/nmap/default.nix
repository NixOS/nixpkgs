{ stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig
, openssl, python, pygtk, makeWrapper, pygobject
, pycairo, pysqlite
}:

stdenv.mkDerivation rec {
  name = "nmap-6.40";

  src = fetchurl {
    url = "http://nmap.org/dist/${name}.tar.bz2";
    sha256 = "491f77d8b3fb3bb38ba4e3850011fe6fb43bbe197f9382b88cb59fa4e8f7a401";
  };

  patches = [ ./zenmap.patch ];

  postInstall =
    ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
    '';

  buildInputs =
    [ libpcap libX11 gtk pkgconfig openssl python pygtk makeWrapper pysqlite ];
}
