{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${VERSION}";
  # This environment variable is read by make to set the build version.
  VERSION = "1.2";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${VERSION}";
    sha256 = "0bpqlbsjcmcizgw75j1zyw1sp2cgwhaar9y70sibw1km011yqbzd";
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
