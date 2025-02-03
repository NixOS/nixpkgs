{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchpatch
}:

buildNpmPackage rec {
  pname = "emmet-ls";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "aca";
    repo = "emmet-ls";
    rev = version;
    hash = "sha256-TmsJpVLF9FZf/6uOM9LZBKC6S3bMPjA3QMiRMPaY9Dg=";
  };

  npmDepsHash = "sha256-Boaxkad7S6H+eTW5AHwBa/zj/f1oAGGSsmW1QrzuFWc=";

  patches = [
    # update package-lock.json as it is outdated
    (fetchpatch {
      name = "fix-lock-file-to-match-package-json.patch";
      url = "https://github.com/aca/emmet-ls/commit/111111a2c2113f751fa12a716ccfbeae61c32079.patch";
      hash = "sha256-/3ZbOBxScnfhL1F66cnIoD2flVeYTJ2sLxNHQ9Yrgjw=";
    })
  ];

  meta = with lib; {
    description = "Emmet support based on LSP";
    homepage = "https://github.com/aca/emmet-ls";
    changelog = "https://github.com/aca/emmet-ls/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "emmet-ls";
  };
}
