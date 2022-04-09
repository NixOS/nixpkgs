{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation {
  pname = "disk-indicator";
  version = "unstable-2014-05-19";

  src = fetchFromGitHub {
    owner = "MeanEYE";
    repo = "Disk-Indicator";
    rev = "51ef4afd8141b8d0659cbc7dc62189c56ae9c2da";
    sha256 = "sha256-bRaVEe18VUmyftXzMNmGuL5gZ/dKCipuEDYrnHo1XYI=";
  };

  buildInputs = [ libX11 ];

  patchPhase = ''
    substituteInPlace ./makefile --replace "COMPILER=c99" "COMPILER=gcc -std=c99"
    substituteInPlace ./makefile --replace "COMPILE_FLAGS=" "COMPILE_FLAGS=-O2 "
  '';

  buildPhase = "make -f makefile";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp ./disk_indicator "$out/bin/"
  '';

  meta = {
    homepage = "https://github.com/MeanEYE/Disk-Indicator";
    description = "A program that will turn a LED into a hard disk indicator";
    longDescription = ''
      Small program for Linux that will turn your Scroll, Caps or Num Lock LED
      or LED on your ThinkPad laptop into a hard disk activity indicator.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
