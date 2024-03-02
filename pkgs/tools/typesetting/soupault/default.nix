{ lib
, fetchFromGitea
, ocamlPackages
, soupault
, testers
}:

let
  pname = "soupault";

  version = "4.8.0";
in
ocamlPackages.buildDunePackage {
  inherit pname version;

  minimalOCamlVersion = "4.13";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    hash = "sha256-/QpT0zgrfMgRKjHyLHugaAlICpPkqaQ7f8fFAL0P02Y=";
  };

  buildInputs = with ocamlPackages; [
    base64
    camomile
    containers
    csv
    digestif
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

  passthru.tests.version = testers.testVersion {
    package = soupault;
    command = "soupault --version-number";
  };

  meta = {
    description = "A tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    changelog = "https://codeberg.org/PataphysicalSociety/soupault/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "soupault";
  };
}
