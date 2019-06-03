{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${VERSION}";
  # This environment variable is read by make to set the build version.
  VERSION = "1.3";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${VERSION}";
    sha256 = "0fwbx0y80nqgkxrc9kf9j3iwa0wbps2jmqir3pgqbc2cj0wjh0lr";
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
