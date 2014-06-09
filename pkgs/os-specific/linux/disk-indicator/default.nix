{ stdenv, fetchgit, libX11 }:

stdenv.mkDerivation {
  name = "disk-indicator";

  src = fetchgit {
    url = git://github.com/MeanEYE/Disk-Indicator.git;
    rev = "51ef4afd8141b8d0659cbc7dc62189c56ae9c2da";
    sha256 = "0f8mxl3wqlap8zajdk6r9liliayp8w4xs4jy8jbwanmmppwz0nb9";
  };

  buildInputs = [ libX11 ];

  patchPhase = ''
    substituteInPlace ./makefile --replace "COMPILER=c99" "COMPILER=gcc -std=c99"
    substituteInPlace ./makefile --replace "COMPILE_FLAGS=" "COMPILE_FLAGS=-O2 "
  '';

  buildPhase = "make -f makefile";

  installPhase = ''
    mkdir -p "$out/bin"
    cp ./disk_indicator "$out/bin/"
  '';

  meta = {
    homepage = https://github.com/MeanEYE/Disk-Indicator;
    description = "A program that will turn a LED into a hard disk indicator";
    longDescription = ''
      Small program for Linux that will turn your Scroll, Caps or Num Lock LED
      or LED on your ThinkPad laptop into a hard disk activity indicator.
    '';
    license = "GPLv3";
    platforms = stdenv.lib.platforms.linux;
  };
}
