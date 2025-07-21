{
  rocq-core,
  mkRocqDerivation,
  lib,
  version ? null,
}:
mkRocqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "rocq-prover";
  opam-name = "rocq-stdlib";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.version [
      (case (range "9.0" "9.1") "9.0.0")
    ] null;
  releaseRev = v: "V${v}";

  release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";

  mlPlugin = true;

  meta = {
    description = "The Rocq Proof Assistant -- Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}
