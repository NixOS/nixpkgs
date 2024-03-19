{ lib, stdenv, fetchFromGitHub, fetchurl, SDL2, SDL2_ttf }:

let
  font = fetchurl {
    url    = "http://kingbird.myphotos.cc/ee22d44076adb8a34d8e20df4be3730a/SnipesConsole.ttf";
    sha256 = "06n8gq18js0bv4svx84ljzhs9zmi81wy0zqcqj3b4g0rsrkr20a7";
  };

in stdenv.mkDerivation {
  pname = "snipes";
  version = "20180930";

  src = fetchFromGitHub {
    owner  = "Davidebyzero";
    repo   = "Snipes";
    rev    = "594af45108e07aa4159c3babc9b5e53609c3fd6e";
    sha256 = "0gmh38swm74jmljy0bq27ipqzb4h8y9rzwc1j6harbd9qqz5knac";
  };

  postPatch = ''
    substitute config-sample.h config.h \
      --replace SnipesConsole.ttf $out/share/snipes/SnipesConsole.ttf
    substituteInPlace GNUmakefile \
      --replace 'CFLAGS=-Werror -Wall' 'CFLAGS=-Wall'
  '';

  enableParallelBuilding = true;

  buildInputs = [ SDL2 SDL2_ttf ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin snipes
    install -Dm644 -t $out/share/doc/snipes *.md
    install -Dm644 ${font} $out/share/snipes/SnipesConsole.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern port of the classic 1982 text-mode game Snipes";
    mainProgram = "snipes";
    homepage    = "https://www.vogons.org/viewtopic.php?f=7&t=49073";
    license     = licenses.free; # This reverse-engineered source code is released with the original authors' permission.
    maintainers = with maintainers; [ peterhoeg ];
  };
}
