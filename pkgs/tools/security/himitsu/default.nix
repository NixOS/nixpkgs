{
  lib,
  stdenv,
  fetchFromSourcehut,
  hare,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "himitsu";
  version = "0.6";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = version;
    hash = "sha256-3x6Lc1rWBtYWVocBuMV5CtoZQjL0Ce+6J2xFjaYaeG4=";
  };

  nativeBuildInputs = [
    hare
    scdoc
  ];

  preConfigure = ''
    export HARECACHE=$(mktemp -d)
  '';

  installFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    homepage = "https://himitsustore.org/";
    description = "A secret storage manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
