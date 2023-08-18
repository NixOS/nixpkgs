{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokecrystal";
  version = "unstable-2023-08-16";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokecrystal";
    rev = "0d899cbd3b318b50776aac0a4aafad6133a5e647";
    hash = "sha256-dwtvNfpFHPeM5syCd9IUPRM/QDGFO//hNz59VaP4sao=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp pokecrystal.gbc $out/rom/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Pokemon Crystal decomp";
    homepage = "https://github.com/pret/pokecrystal/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
