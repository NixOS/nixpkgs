{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff
, tcl-8_5 }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.5.5";
  src = fetchurl {
    url = "http://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1xm6ikzx8iaa6r7v292k8s7srkzhnifamp1szkimgmh5ki26sa1s";
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
