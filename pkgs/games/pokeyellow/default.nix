{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokered";
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeyellow";
    rev = "613e1c64bd9668f996bb42ead52eabf1ae45a660";
    hash = "sha256-uUUBkSGkZrQtigIwaaCTty3hHj2d94TFC2AFZeTZev4=";
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
    description = "Pokemon Yellow decomp";
    homepage = "https://github.com/pret/pokeyellow/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
