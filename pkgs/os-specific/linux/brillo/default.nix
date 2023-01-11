{ lib, stdenv, fetchFromGitLab , go-md2man, coreutils, substituteAll }:

stdenv.mkDerivation rec {
  pname = "brillo";
  version = "1.4.11";

  src = fetchFromGitLab {
    owner= "cameronnemo";
    repo= "brillo";
    rev= "v${version}";
    sha256 = "sha256-R83Zx0dw9bmCF5kHTNYoNzCmJZK3cVzXNb30qAUexFc=";
  };

  patches = [
    (substituteAll {
      src = ./udev-rule.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [ go-md2man ];

  makeFlags = [ "PREFIX=$(out)" "AADIR=$(out)/etc/apparmor.d" ];

  installTargets = [ "install-dist" ];

  meta = with lib; {
    description = "Backlight and Keyboard LED control tool";
    homepage = "https://gitlab.com/cameronnemo/brillo";
    license = [ licenses.gpl3 licenses.bsd0 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.alexarice ];
  };
}
