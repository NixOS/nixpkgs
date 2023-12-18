{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "igir";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-HIhk60I5VUMHBUp5EQGpE7RZ0KiYwVMl1jEX9zb5ttA=";
  };

  npmDepsHash = "sha256-P+H6q+jwfJFMb5qtOS3OCVUu9MtZ+Knaog0qyP3FpFo=";

  # I have no clue why I have to do this
  postPatch = ''
    patchShebangs scripts/update-readme-help.sh
  '';

  meta = with lib; {
    description = "A video game ROM collection manager to help filter, sort, patch, archive, and report on collections on any OS";
    homepage = "https://igir.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
