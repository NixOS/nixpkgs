{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff
, tcl-8_5 }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.5.6";

  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1s2cci80g6kbp5p77mkxpfxwvjm1802fw0bjfsa8yjv8g5a7fclq";
  };

  buildInputs = [ gettext perl pkgconfig libxml2 pango cairo groff ]
    ++ stdenv.lib.optional stdenv.isDarwin tcl-8_5;

  postInstall = ''
    # for munin and rrdtool support
    mkdir -p $out/lib/perl5/site_perl/
    mv $out/lib/perl/5* $out/lib/perl5/site_perl/
  '';

  meta = with stdenv.lib; {
    homepage = http://oss.oetiker.ch/rrdtool/;
    description = "High performance logging in Round Robin Databases";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
