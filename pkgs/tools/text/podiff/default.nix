{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "podiff-${version}";
  version = "1.1";

  src = fetchurl {
    url = "ftp://download.gnu.org.ua/pub/release/podiff/podiff-1.1.tar.gz";
    sha256 = "1zz6bcmka5zvk2rq775qv122lqh54aijkxlghvx7z0r6kh880x59";
  };

  patchPhase = ''
    sed "s#PREFIX=/usr#PREFIX=$out#g" -i Makefile
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Finds differences in translations between two PO files, or revisions";
    homepage = http://puszcza.gnu.org.ua/software/podiff;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.goibhniu ];
  };
}
