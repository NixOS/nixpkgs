{ fetchFromGitHub, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo, groff
, tcl-8_5, darwin }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.7.0.2017-06-23";

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "rrdtool-1.x";
    rev = "e0eb6257ad9b150636ef0ccc3797b71e6a3e822a";
    sha256 = "0szjnvwailsianlhxvvgzr97d78nvkkid3imcfvawy5w4x6bvasv";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gettext perl libxml2 pango cairo groff ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ tcl-8_5 darwin.apple_sdk.frameworks.ApplicationServices ];

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
