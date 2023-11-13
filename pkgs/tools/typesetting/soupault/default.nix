{ lib
, fetchFromGitea
, fetchpatch
, ocamlPackages
, soupault
, testers
}:

let
  pname = "soupault";

  version = "4.7.0";
in
ocamlPackages.buildDunePackage {
  inherit pname version;

  minimalOCamlVersion = "4.13";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    sha256 = "nwXyOwDUbkMnyHPrvCvmToyONdbg5kJm2mt5rWrB6HA=";
  };

  patches = lib.lists.optional
    (lib.strings.versionAtLeast "2.0.0" ocamlPackages.camomile.version)
    (fetchpatch {
      name = "camomile-1_x";
      url = "https://files.baturin.org/software/soupault/soupault-4.7.0-camomile-1.x.patch";
      sha256 = "V7+OUjXqWtXwjUa35MlY9iyAlqOkst9Th7DgfDXkXZg=";
    });

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
