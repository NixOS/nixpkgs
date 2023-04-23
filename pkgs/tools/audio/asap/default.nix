{ stdenv
, lib
, fetchzip
, SDL
}:

stdenv.mkDerivation rec {
  pname = "asap";
  version = "5.2.0";

  src = fetchzip {
    url = "mirror://sourceforge/project/asap/asap/${version}/asap-${version}.tar.gz";
    sha256 = "1riwfds5ipgh19i3ibsyqhxlh70xix9452y4wqih9xdkixmxqbqm";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    SDL
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    # Only targets that don't need cito transpiler
    "asapconv"
    "asap-sdl"
    "lib"
  ];

  installFlags = [
    "prefix=${placeholder "dev"}"
    "bindir=${placeholder "out"}/bin"
    "install-asapconv"
    "install-sdl"
    "install-lib"
  ];

  meta = with lib; {
    homepage = "https://asap.sourceforge.net/";
    mainProgram = "asap-sdl";
    description = "Another Slight Atari Player";
    longDescription = ''
      ASAP (Another Slight Atari Player) plays and converts 8-bit Atari POKEY
      music (*.sap, *.cmc, *.mpt, *.rmt, *.tmc, ...) on modern computers and
      mobile devices.
    '';
    maintainers = with maintainers; [ OPNA2608 ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
