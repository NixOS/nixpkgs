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
      (case (range "9.0" "9.2") "0.5.0")
    ] null;
  release = {
    "0.5.0".hash = "sha256-pmK4gD5ccerjr2UVgwGIVbjH/RiXdYQq79/XFetiHZg=";
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
