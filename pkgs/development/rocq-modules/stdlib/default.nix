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
    lib.switch rocq-core.version [
      { case = isEq "9.0"; out = "9.0.0"; }
      # the one below is artificial as stdlib was included in Coq before
      { case = isLt "9.0"; out = "9.0.0"; }
    ] null;
  releaseRev = v: "V${v}";

  release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";

  mlPlugin = true;

  meta = {
    description = "The Rocq Proof Assistant -- Standard Library";
    license = lib.licenses.lgpl21Only;
  };

}
