{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

with lib;
mkRocqDerivation {
  pname = "rocqnavi";
  owner = "affeldt-aist";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with versions;
    switch rocq-core.rocq-version [
      (case (range "9.0" "9.3") "0.5.1")
    ] null;
  release = {
    "0.5.1".hash = "sha256-QfEP4qBbP0FLoxnjLe26tmZCpMg7Xu/gk6OXxL6Fdc4=";
  };
  releaseRev = v: "rocqnavi." + v;

  nativeBuildInputs =
    let
      ocamlpkgs = rocq-core.ocamlPackages;
    in
    [
      ocamlpkgs.yojson
      ocamlpkgs.dune-glob
    ];

  ## Does the package contain OCaml code?
  mlPlugin = true;
  buildPhase = "make";
  preInstallPhase = "mkdir $(out)/bin";
  installFlags = [ "BINDIR=$(out)/bin" ];

  meta = {
    description = "Rocqnavi: an HTML documentation generator for Rocq prover";
    maintainers = with maintainers; [ cohencyril ];
    license = licenses.gpl2;
  };
}
