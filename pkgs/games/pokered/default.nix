{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokered";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokered";
    rev = "fa18a75dc55c58505b7c643560bc7d8f1198995b";
    hash = "sha256-+bRXXdrpmuQ3pwRVrKFx01CkfaSnr5GJuN5L3dl9szM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp poke*.gbc $out/rom/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Pokemon Red/Blue decomp";
    homepage = "https://github.com/pret/pokered/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
