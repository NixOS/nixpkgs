{ lib, fetchFromGitHub, fetchzip, stdenv }:

rec {
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-4fNBpokHKCtMB3P0ot1TzcuzOs5hlyH8nIw+bCGqThA=";
  };

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/lang" = fetchFromGitHub {
      owner = "returntocorp";
      repo = "semgrep-langs";
      rev = "65cb2ed80e31e01b122f893fef8428d14432da75";
      sha256 = "sha256-HdPJdOlMM1l7vNSATkEu5KrCkpt2feEAH8LFDU84KUM=";
    };
    "cli/src/semgrep/semgrep_interfaces" = fetchFromGitHub {
      owner = "returntocorp";
      repo = "semgrep-interfaces";
      rev = "c69e30a4cf39f11cab5378700f5e193e8282079e";
      sha256 = "sha256-Wr3/TWx/LHiTFCoGY4sqdsn3dHvMsEIVYA3RGiv88xQ=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  core = rec {
    data = {
      x86_64-linux = {
        suffix = "-ubuntu-16.04.tgz";
        sha256 = "sha256-SsaAuhcDyO3nr6H2xOtdxzOoEQd6aIe0mlpehvDWzU0=";
      };
      x86_64-darwin = {
        suffix = "-osx.zip";
        sha256 = "sha256-DAcAB/q6XeljCp4mVljIJB4AUjUuzMSRMFzIuyjWMew=";
      };
    };
    src = let
      inherit (stdenv.hostPlatform) system;
      selectSystemData = data: data.${system} or (throw "Unsupported system: ${system}");
      inherit (selectSystemData data) suffix sha256;
    in fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}${suffix}";
      inherit sha256;
    };
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
