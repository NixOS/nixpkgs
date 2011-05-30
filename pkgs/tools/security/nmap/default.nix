{ stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig
, openssl, python, pygtk, makeWrapper, pygobject
, pycairo, pysqlite
}:
  
stdenv.mkDerivation rec {
  name = "nmap-5.50";

  src = fetchurl {
    url = "http://nmap.org/dist/${name}.tar.bz2";
    sha256 = "aa044113caa47e172c154daed73afc70ffa18d359eb47c22a9ea85ffcb14ffb8";
  };

  postInstall =
    ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
    '';

  buildInputs =
    [ libpcap libX11 gtk pkgconfig openssl python pygtk makeWrapper pysqlite ];
}
