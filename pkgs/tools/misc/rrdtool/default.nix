{ fetchurl, lib, stdenv, gettext, perl, pkg-config, libxml2, pango, cairo, groff
, tcl-8_5, darwin }:

stdenv.mkDerivation rec {
  name = "rrdtool-1.7.2";

  src = fetchurl {
    url = "https://oss.oetiker.ch/rrdtool/pub/${name}.tar.gz";
    sha256 = "1nsqra0g2nja19akmf9x5y9hhgc35ml3w9dcdz2ayz7zgvmzm6d1";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gettext perl libxml2 pango cairo groff ]
    ++ lib.optionals stdenv.isDarwin [ tcl-8_5 darwin.apple_sdk.frameworks.ApplicationServices ];

  postInstall = ''
    # for munin and rrdtool support
    mkdir -p $out/${perl.libPrefix}
    mv $out/lib/perl/5* $out/${perl.libPrefix}
  '';

  meta = with lib; {
    homepage = "https://oss.oetiker.ch/rrdtool/";
    description = "High performance logging in Round Robin Databases";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
