{ lib, fetchFromGitHub, stdenv, zlib }:

stdenv.mkDerivation rec {
  pname = "vdexExtractor";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "vdexExtractor";
    rev = version;
    sha256 = "sha256-dSzNK1dvllmY9HcA7u0tbhDM8tY/I6GqzgAJ56mB5vE=";
  };

  # No tests
  doCheck = false;

  postPatch = ''
    patchShebangs make.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./make.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D bin/vdexExtractor $out/bin/vdexExtractor

    runHook postInstall
  '';

  buildInputs = [
    zlib
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=stringop-truncation"
  ];

  meta = with lib; {
    description = "Tool to decompile & extract Android Dex bytecode from Vdex files";
    homepage = "https://github.com/anestisb/vdexExtractor";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ambroisie ];
  };
}
