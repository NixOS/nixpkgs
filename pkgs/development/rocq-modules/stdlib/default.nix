{
  rocq-core,
  mkRocqDerivation,
  lib,
  version ? null,
}:
mkRocqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "rocq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch rocq-core.version (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: case: { inherit case out; }) {
        "9.0.0" = isEq "9.0";
      }
    )) null;
  releaseRev = v: "V${v}";

  release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";

  mlPlugin = true;

  meta = {
    description = "The Rocq Proof Assistant -- Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}
