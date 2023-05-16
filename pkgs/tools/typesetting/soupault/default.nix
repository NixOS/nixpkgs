{ lib
, fetchFromGitea
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ocamlPackages
, soupault
, testers
}:

let
  pname = "soupault";

<<<<<<< HEAD
  version = "4.6.0";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
ocamlPackages.buildDunePackage {
  inherit pname version;

  minimalOCamlVersion = "4.13";

  duneVersion = "3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "MblwVacfK9CfoO0TEND+bqdi7iQayBOJKKOhzE7oiVk=";
  };

  patches = lib.lists.optional
    (lib.strings.versionAtLeast "2.0.0" ocamlPackages.camomile.version)
    (fetchpatch {
      name = "camomile-1_x";
      url = "https://files.baturin.org/software/soupault/soupault-4.6.0-camomile-1.x.patch";
      sha256 = "J5RGyLDDVRzf6MLLI+73lqClxoovcPD2ZFawk+f6cE4=";
    });

=======
    sha256 = "sha256-M4gaPxBxQ1Bk2C3BwvobYHyaWKIZgQ6buZ6S5wBlvPg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = with ocamlPackages; [
    base64
    camomile
    containers
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
  };
}
