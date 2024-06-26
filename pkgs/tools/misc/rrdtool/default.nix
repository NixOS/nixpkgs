{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  perl,
  pkg-config,
  libxml2,
  pango,
  cairo,
  groff,
  tcl,
  darwin,
}:

perl.pkgs.toPerlModule (
  stdenv.mkDerivation rec {
    pname = "rrdtool";
    version = "1.8.0";

    src = fetchFromGitHub {
      owner = "oetiker";
      repo = "rrdtool-1.x";
      rev = "v${version}";
      hash = "sha256-a+AxU1+YpkGoFs1Iu/CHAEZ4XIkWs7Vsnr6RcfXzsBE=";
    };

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];

    buildInputs =
      [
        gettext
        perl
        libxml2
        pango
        cairo
        groff
      ]
      ++ lib.optionals stdenv.isDarwin [
        tcl
        darwin.apple_sdk.frameworks.ApplicationServices
      ];

    postInstall = ''
      # for munin and rrdtool support
      mkdir -p $out/${perl.libPrefix}
      mv $out/lib/perl/5* $out/${perl.libPrefix}
    '';

    meta = with lib; {
      homepage = "https://oss.oetiker.ch/rrdtool/";
      description = "High performance logging in Round Robin Databases";
      license = licenses.gpl2Only;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = with maintainers; [ pSub ];
    };
  }
)
