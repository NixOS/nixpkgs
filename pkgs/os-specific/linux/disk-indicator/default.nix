{ stdenv, fetchgit, libX11 }:

stdenv.mkDerivation {
  name = "disk-indicator-2018-12-18";

  src = fetchgit {
    url = git://github.com/MeanEYE/Disk-Indicator.git;
    rev = "ec2d2f6833f038f07a72d15e2d52625c23e10b12";
    sha256 = "08q9cnjgxscx5rcn1nxdzsb81mam2yh8aqff4sr5a7vs24is06ki";
  };

  buildInputs = [ libX11 ];

  patchPhase = ''
    substituteInPlace ./Makefile --replace "COMPILER=c99" "COMPILER=gcc -std=c99"
    substituteInPlace ./Makefile --replace "COMPILE_FLAGS=" "COMPILE_FLAGS=-O2 "
    patchShebangs ./configure.sh
  '';

  configurePhase = "./configure.sh --all";
  buildPhase = "make -f Makefile";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  hardeningDisable = [ "fortify" ];

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
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
