{
  lib,
  fetchFromGitHub,
  ocaml,
  buildDunePackage,
  fix,
  menhirLib,
  menhirSdk,
  gitUpdater,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "ocaml-recovery-parser is not available for OCaml ${ocaml.version}"

  buildDunePackage
  rec {
    pname = "ocaml-recovery-parser";
    version = "0.2.4";

    minimalOCamlVersion = "4.08";
    duneVersion = "3";

    src = fetchFromGitHub {
      owner = "serokell";
      repo = pname;
      rev = version;
      sha256 = "gOKvjmlcHDOgsTllj2sPL/qNtW/rlNlEVIrosahNsAQ=";
    };

    propagatedBuildInputs = [
      fix
      menhirLib
      menhirSdk
    ];

    passthru.updateScript = gitUpdater { };

    meta = with lib; {
      description = "A simple fork of OCaml parser with support for error recovery";
      homepage = "https://github.com/serokell/ocaml-recovery-parser";
      license = with licenses; [
        lgpl2Only
        mit
        mpl20
      ];
      maintainers = with maintainers; [ romildo ];
      mainProgram = "menhir-recover";
    };
  }
