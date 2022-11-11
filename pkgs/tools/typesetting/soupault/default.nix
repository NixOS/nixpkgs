{ lib
, fetchFromGitea
, ocamlPackages
, soupault
, testers
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "4.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    sha256 = "sha256-K5JlMf9hCUI3BTDRP6wIgNYu+MM3tanHAgnAYw4oXag=";
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
  };
}
