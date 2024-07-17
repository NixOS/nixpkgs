{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation rec {
  pname = "beep";
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "spkr-beep";
    repo = "beep";
    rev = "v${version}";
    sha256 = "sha256-gDgGI9F+wW2cN89IwP93PkMv6vixJA2JckF78nxZ+TU=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "The advanced PC speaker beeper";
    homepage = "https://github.com/spkr-beep/beep";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    mainProgram = "beep";
  };
}
