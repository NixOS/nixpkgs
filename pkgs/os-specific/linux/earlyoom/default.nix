{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${VERSION}";
  # This environment variable is read by make to set the build version.
  VERSION = "1.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${VERSION}";
    sha256 = "1hczn59mmx287hnlhcmpxrf3jy3arllif165dq7b2ha6w3ywngww";
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
