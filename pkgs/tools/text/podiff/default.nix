{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "podiff";
  version = "1.3";

  src = fetchurl {
    url = "ftp://download.gnu.org.ua/pub/release/podiff/podiff-1.3.tar.gz";
    sha256 = "sha256-7fpix+GkXsfpRgnkHtk1iXF6ILHri7BtUhNPK6sDQFA=";
  };

  patchPhase = ''
    sed "s#PREFIX=/usr#PREFIX=$out#g" -i Makefile
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = with lib; {
    description = "Finds differences in translations between two PO files, or revisions";
    homepage = "http://puszcza.gnu.org.ua/software/podiff";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
