{ lib
, fetchFromGitea
, ocamlPackages
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "4.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ojsup/BgXsqhRUsU6JevvuLnMtVs2Kd5kTeDvVO5BOk=";
  };

  buildInputs = with ocamlPackages; [
    base64
    camomile
    containers
    ezjsonm
    fileutils
    fmt
    jingoo
    lambdasoup
    lua-ml
    logs
    markup
    odate
    otoml
    re
    spelll
    tsort
    yaml
  ];

  meta = {
    description = "A tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    changelog = "https://codeberg.org/PataphysicalSociety/soupault/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
