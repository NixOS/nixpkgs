{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff
, tcl-8_5 }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.6.0";

  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1msj1qsy3sdmx2g2rngp9a9qv50hz0ih7yx6nkx2b21drn4qx56d";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gettext perl libxml2 pango cairo groff ]
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
