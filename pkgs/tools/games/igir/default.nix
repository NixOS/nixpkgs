{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "igir";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-MlLnnwlqFkzSZi+6OGS/ZPYRPjV7CY/piFvilwhhR9A=";
  };

  npmDepsHash = "sha256-yVo2ZKu2lEOYG12Gk5GQXamprkP5jEyKlSTZdPjNWQM=";

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
