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

buildDunePackage rec {
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

<<<<<<< HEAD
  meta = {
    description = "Simple fork of OCaml parser with support for error recovery";
    homepage = "https://github.com/serokell/ocaml-recovery-parser";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Simple fork of OCaml parser with support for error recovery";
    homepage = "https://github.com/serokell/ocaml-recovery-parser";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl2Only
      mit
      mpl20
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ romildo ];
=======
    maintainers = with maintainers; [ romildo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "menhir-recover";
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
}
