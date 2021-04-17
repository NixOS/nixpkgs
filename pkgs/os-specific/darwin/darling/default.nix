{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname   = "darling";
  version = "unstable-2020-04-26";

  src = fetchFromGitHub {
    owner   = "darlinghq";
    repo    = "darling";
    rev     = "ea5f07d38a0d4667b4fdda42b131250e4b7c7296";
    sha256  = "1qnp4fpnjf95pzxn51rmwadnj24llb64pb127yr2qkw35apbz00c";
  };

  # only packaging sandbox for now
  buildPhase = ''
    cc -c src/sandbox/sandbox.c -o src/sandbox/sandbox.o
    cc -dynamiclib -flat_namespace src/sandbox/sandbox.o -o libsystem_sandbox.dylib
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -rL src/sandbox/include/ $out/
    cp libsystem_sandbox.dylib $out/lib/

    mkdir -p $out/include
    cp src/libaks/include/* $out/include
  '';

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "Darwin/macOS emulation layer for Linux";
    platforms = platforms.darwin;
  };
}
