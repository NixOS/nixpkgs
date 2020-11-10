{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "podiff";
  version = "1.2";

  src = fetchurl {
    url = "ftp://download.gnu.org.ua/pub/release/podiff/podiff-1.2.tar.gz";
    sha256 = "1l2b4hh53xlx28riigwarzkhxpv1pcz059xj1ka33ccvxc6c20k9";
  };

  patchPhase = ''
    sed "s#PREFIX=/usr#PREFIX=$out#g" -i Makefile
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Finds differences in translations between two PO files, or revisions";
    homepage = "http://puszcza.gnu.org.ua/software/podiff";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
