{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.5.5";
  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1xm6ikzx8iaa6r7v292k8s7srkzhnifamp1szkimgmh5ki26sa1s";
  };
  buildInputs = [ gettext perl pkgconfig libxml2 pango cairo groff ];
  
  postInstall = ''
    # for munin support
    mv $out/lib/perl/5*/*/*.pm $out/lib/perl/5*/
  '';

  meta = with stdenv.lib; {
    homepage = http://oss.oetiker.ch/rrdtool/;
    description = "High performance logging in Round Robin Databases";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
