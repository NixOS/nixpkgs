{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.5.3";
  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "17qjqq7k50xfahza1gkcfchzss2jjmgr422dzs4kx13lrzsv5rvr";
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
