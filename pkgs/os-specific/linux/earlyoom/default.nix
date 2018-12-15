{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${VERSION}";
  # This environment variable is read by make to set the build version.
  VERSION = "0.11";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${VERSION}";
    sha256 = "1k3xslb70fzk80wlka32l0k2v45qn1xgwyjkjiz85gv6v4mv92vl";
  };

  installPhase = ''
    install -D earlyoom $out/bin/earlyoom
  '';

  meta = {
    description = "Early OOM Daemon for Linux";
    homepage    = https://github.com/rfjakob/earlyoom;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
