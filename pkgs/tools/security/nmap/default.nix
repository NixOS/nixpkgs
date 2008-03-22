{stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig,
  openssl, python, pygtk, makeWrapper, pygobject,
  pycairo, pysqlite}:
stdenv.mkDerivation {
  name = "Nmap";

  src = fetchurl {
    url = http://download.insecure.org/nmap/dist/nmap-4.60.tar.bz2;
    sha256 = "1jhway86lmrnyzvwi24ama1vrz89f9nmln29vr92kb31aw2nl30w";  };

  postInstall =''
    wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
  '';

  buildInputs = [libpcap libX11 gtk pkgconfig openssl python 
    pygtk makeWrapper pysqlite];
}
