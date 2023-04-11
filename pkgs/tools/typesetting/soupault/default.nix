{ lib
, fetchFromGitea
, ocamlPackages
, soupault
, testers
  # needed while overriding packages
, fetchFromGitHub
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "4.5.0";

  minimalOCamlVersion = "4.13";

  duneVersion = "3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    sha256 = "sha256-LrDP3IX+UARUN98O8yP7lbyWGg2JT7+MtJumW00IiYw=";
  };

  buildInputs = with ocamlPackages; [
    base64
    camlp-streams
    (callPackage ./camomile-2_0_0.nix { })
    containers
    digestif
    dune-site
    ezjsonm
    fileutils
    fmt
    jingoo
    # remove when merged: https://github.com/NixOS/nixpkgs/pull/230755
    (lambdasoup.overrideAttrs (old: rec {
      version = "1.0.0";
      buildInputs = (old.buildInputs or [ ]) ++ (with ocamlPackages; [
        camlp-streams
      ]);
      src = fetchFromGitHub {
        owner = "aantron";
        repo = "lambdasoup";
        rev = version;
        sha256 = "sha256-PZkhN5vkkLu8A3gYrh5O+nq9wFtig0Q4qD8zLGUGTRI=";
      };
    }))
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
