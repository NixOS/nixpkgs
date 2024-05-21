{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation {
  pname = "disk-indicator";
  version = "unstable-2018-12-18";

  src = fetchFromGitHub {
    owner = "MeanEYE";
    repo = "Disk-Indicator";
    rev = "ec2d2f6833f038f07a72d15e2d52625c23e10b12";
    sha256 = "sha256-cRqgIxF6H1WyJs5hhaAXVdWAlv6t22BZLp3p/qRlCSM=";
  };

  buildInputs = [ libX11 ];

  postPatch = ''
    # avoid -Werror
    substituteInPlace Makefile --replace "-Werror" ""
    # avoid host-specific options
    substituteInPlace Makefile --replace "-march=native" ""
  '';

  postConfigure = ''
    patchShebangs ./configure.sh
    ./configure.sh --all
  '';

  makeFlags = [
    "COMPILER=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp ./disk_indicator "$out/bin/"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/MeanEYE/Disk-Indicator";
    description = "A program that will turn a LED into a hard disk indicator";
    mainProgram = "disk_indicator";
    longDescription = ''
      Small program for Linux that will turn your Scroll, Caps or Num Lock LED
      or LED on your ThinkPad laptop into a hard disk activity indicator.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
