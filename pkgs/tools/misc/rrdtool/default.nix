{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.5.4";
  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "169zbidc5h88w064qmj6x5rzczkrrfrcgwc3f2i2h8f0hzda7viz";
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
