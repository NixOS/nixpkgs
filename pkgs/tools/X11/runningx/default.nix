{ lib, stdenv, fetchurl, pkg-config, libX11 }:

stdenv.mkDerivation {
  pname = "runningx";
  version = "1.0";

  src = fetchurl {
    url = "http://www.fiction.net/blong/programs/mutt/autoview/RunningX.c";
    sha256 = "1mikkhrx6jsx716041qdy3nwjac08pxxvxyq2yablm8zg9hrip0d";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libX11 ];

  dontUnpack = true;

  buildPhase = ''
    cc -O2 -o RunningX $(pkg-config --cflags --libs x11) $src
  '';

  installPhase = ''
    mkdir -p "$out"/bin
    cp -vai RunningX "$out/bin"
  '';

  meta = {
    homepage = "http://www.fiction.net/blong/programs/mutt/";
    description = "A program for testing if X is running";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "RunningX";
  };
}
