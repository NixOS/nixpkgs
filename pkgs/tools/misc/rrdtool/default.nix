{ fetchurl, fetchpatch, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff
, tcl-8_5, darwin }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.7.1";

  src = fetchurl {
    url = "https://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1bhsg119j94xwykp2sbp01hhxcg78gzblfn7j98slrv9va77g6wq";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gettext perl libxml2 pango cairo groff ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ tcl-8_5 darwin.apple_sdk.frameworks.ApplicationServices ];

  postInstall = ''
    # for munin and rrdtool support
    mkdir -p $out/${perl.libPrefix}
    mv $out/lib/perl/5* $out/${perl.libPrefix}
  '';

  meta = with stdenv.lib; {
    homepage = https://oss.oetiker.ch/rrdtool/;
    description = "High performance logging in Round Robin Databases";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
