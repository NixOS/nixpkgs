{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation rec {
  pname = "uxn";
  version = "2021-08-26-c6c31aa";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = pname;
    rev = "c6c31aa81546ac2348efd4031e3130ca22e9d9a0";
    sha256 = "0r3qpx4cwbd9plp4y0yk14ys3impm31d47sa93d4n7vr4j7p7aim";
  };

  buildInputs = [ SDL2 ];

  buildPhase = ''
    runHook preBuild

    CFLAGS="-std=c89 -Wall -Wno-unknown-pragmas -DNDEBUG -Os -g0 -s"
    UXNEMU_LDFLAGS="$(sdl2-config --cflags --libs)"

    mkdir bin
    cc $CFLAGS src/uxnasm.c -o bin/uxnasm
    cc $CFLAGS src/uxn-fast.c src/devices/ppu.c src/devices/apu.c src/uxnemu.c $UXNEMU_LDFLAGS -o bin/uxnemu
    cc $CFLAGS src/uxn-fast.c src/uxncli.c -o bin/uxncli

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    cp ./bin/uxnemu "$out/bin/"
    cp ./bin/uxnasm "$out/bin/"
    cp ./bin/uxncli "$out/bin/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "An assembler and emulator for the Uxn stack-machine";
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    licence = licenses.mit;
  };
}
