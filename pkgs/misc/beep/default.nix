{ lib, stdenv, fetchFromGitHub }:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation rec {
  pname = "beep";
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "spkr-beep";
    repo = "beep";
    rev = "v${version}";
    sha256 = "sha256-8g9Nni9lalQvrffhwIv2LFRtLrioUL+lMeDTHH6l6Sk=";
  };

  makeFlags = [ "DESTDIR=\${out}" "prefix="];

  meta = with lib; {
    description = "The advanced PC speaker beeper";
    homepage = "https://github.com/spkr-beep/beep";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
