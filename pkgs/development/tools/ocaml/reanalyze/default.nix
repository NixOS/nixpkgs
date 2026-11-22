{
  lib,
  ocaml,
  buildDunePackage,
  fetchFromGitHub,
  cppo,
}:

buildDunePackage rec {
  pname = "reanalyze";
  version = "2.25.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "reanalyze";
    tag = "v${version}";
    hash = "sha256-cM39Gk4Ko7o/DyhrzgEHilobaB3h91Knltkcv2sglFw=";
  };

  nativeBuildInputs = [ cppo ];

  meta = {
    description = "Program analysis for ReScript and OCaml projects";
    homepage = "https://github.com/rescript-lang/reanalyze/";
    changelog = "https://github.com/rescript-lang/reanalyze/blob/v${version}/Changes.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    broken = lib.versionAtLeast ocaml.version "5.3";
  };
}
