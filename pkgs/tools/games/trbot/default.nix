{ lib
, buildDotnetModule
, fetchFromGitea
}:

buildDotnetModule rec {
  pname = "trbot";
  version = "2.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "kimimaru";
    repo = "TRBot";
    rev = version;
    sha256 = "sha256-uOHpj2G3BRZJ4P9CENltOCmAnpmnyoJX3uklFiTsaac=";
  };

  nugetDeps = ./deps.nix;

  projectFile = "TRBot/TRBot.sln";

  runtimeDeps = [
  ];

  meta = with lib; {
    description = "Play video games remotely and collaboratively with text";
    homepage = "https://codeberg.org/kimimaru/TRBot";
    downloadPage = "https://codeberg.org/kimimaru/TRBot/releases";
    changelog = "https://codeberg.org/kimimaru/TRBot/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ huantian ];
    mainPrograms = "TRBot";
    platforms = platforms.linux;
  };
}
