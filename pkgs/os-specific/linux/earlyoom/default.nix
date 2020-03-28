{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${VERSION}";
  # This environment variable is read by make to set the build version.
  VERSION = "1.5";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${VERSION}";
    sha256 = "1wcw2lfd9ajachbrjqywkzj9x6zv32gij2r6yap26x1wdd5x7i93";
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
