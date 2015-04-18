{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.4.9";
  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1k1506v86nijd9vdljib93z4hrwj786kqnx37lqqbbqasvh2ca1y";
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
