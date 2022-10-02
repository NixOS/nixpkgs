{ lib, fetchFromGitHub, fetchzip, stdenv }:

rec {
  version = "0.112.1";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-SZtxZz4x6YUKw1uO5HQTU4lRY989SoCNsPQphJr+L0Y=";
  };

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  langsSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-langs";
    rev = "91e288062eb794e8a5e6967d1009624237793491";
    sha256 = "sha256-z2t2bTRyj5zu9h/GBg2YeRFimpJsd3dA7dK8VBaKzHo=";
  };

  interfacesSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-interfaces";
    rev = "7bc457a32e088ef21adf1529fa0ddeea634b9131";
    sha256 = "sha256-xN8Qm1/YLa49k9fZKDoPPmHASI2ipI3mkKlwEK2ajO4=";
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  coreRelease = if stdenv.isDarwin then fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-osx.zip";
      sha256 = "sha256-JiOH39vMDL6r9WKuPO0CDkRwGZtzl/GIFoSegVddFpw=";
  } else fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
      sha256 = "sha256-V6r+VQrgz8uVSbRa2AmW4lnLxovk63FL7LqVKD46RBw=";
  };

  meta = with lib; {
    homepage = "https://semgrep.dev/";
    downloadPage = "https://github.com/returntocorp/semgrep/";
    changelog = "https://github.com/returntocorp/semgrep/blob/v${version}/CHANGELOG.md";
    description = "Lightweight static analysis for many languages";
    longDescription = ''
      Semgrep is a fast, open-source, static analysis tool for finding bugs and
      enforcing code standards at editor, commit, and CI time. Semgrep analyzes
      code locally on your computer or in your build environment: code is never
      uploaded. Its rules look like the code you already write; no abstract
      syntax trees, regex wrestling, or painful DSLs.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jk ambroisie ];
    # limited by semgrep-core
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
