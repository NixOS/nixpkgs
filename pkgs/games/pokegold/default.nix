{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokecrystal";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokegold";
    rev = "e06a6b1550abb88e24980493615e96393cd7ce98";
    hash = "sha256-ZuhamUMKGHGam84a27YyYbpuVWnoH/Vo0E6sc3BSMPk=";
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
    description = "Pokemon Gold/SIlver decomp";
    homepage = "https://github.com/pret/pokegold/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
