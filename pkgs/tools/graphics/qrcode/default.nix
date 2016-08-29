{ stdenv, fetchgit }:
let
  s =
  rec {
    baseName = "qrcode";
    date = "2014-01-01";
    version = "git-${date}";
    name = "${baseName}-${version}";
    url = "https://github.com/qsantos/qrcode";
    rev = "2843cbada3b768f60ee1ae13c65160083558cc03";
    sha256 = "1qli0b62yngqj66v6vdqqgcysy3q3fr5vwpf7yf0d9a0dg862x8a";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;

  src = fetchgit {
    inherit (s) rev url sha256;
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  meta = {
    inherit (s) version;
    description = ''A small QR-code tool'';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
