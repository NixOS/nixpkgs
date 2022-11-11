{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "starfetch";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "Haruno19";
    repo = "starfetch";
    rev = version;
    sha256 = "sha256-2npevr3eSFhB58gRB2IuG4nwzPEGr0xcoSa/4VS0DNg=";
  };

  postPatch = ''
    substituteInPlace src/starfetch.cpp --replace /usr/local/ $out/
  '' + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace makefile --replace g++ clang++
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/starfetch
    cp starfetch $out/bin/
    cp -r res/* $out/share/starfetch/

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI star constellations displayer";
    homepage = "https://github.com/Haruno19/starfetch";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
