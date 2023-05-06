{ lib
, stdenv
, fetchFromSourcehut
}:

stdenv.mkDerivation {
  pname = "evhz";
  version = "unstable-2021-09-20";

  src = fetchFromSourcehut {
    owner = "~iank";
    repo = "evhz";
    rev = "35b7526e0655522bbdf92f6384f4e9dff74f38a0";
    hash = "sha256-lC0CeN9YVhkSiooC59Dbom811jHvPDQcYl+KADUwVdQ=";
  };

  buildPhase = "gcc -o evhz evhz.c";

  installPhase = ''
    mkdir -p $out/bin
    mv evhz $out/bin
  '';

  meta = with lib; {
    description = "Show mouse refresh rate under linux + evdev";
    homepage = "https://git.sr.ht/~iank/evhz";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Tungsten842 ];
    platforms = platforms.linux;
  };
}
