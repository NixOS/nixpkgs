{
  lib,
  mkRocqDerivation,
  rocq-core,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  pname = "LibHyps";
  owner = "Matafou";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.version [
      (case (range "9.0" "9.3") "4.0.0")
      (case (range "8.11" "9.0") "libhyps-2.0.8")
    ] null;
  release = {
    "4.0.0".hash = "sha256-uC23nWdgwD5lw3gdwS4h5ZfK0uG+cboWWldNpedn2EA=";
    "libhyps-2.0.8".hash = "sha256-u8T7ZWfgYNFBsIPss0uUS0oBvdlwPp3t5yYIMjYzfLc=";
  };

  useCoqifVersion = v: v != null && v == "libhyps-2.0.8";

  configureScript = "./configure.sh";

  propagatedBuildInputs = [ stdlib ];

  meta = {
    description = "Hypotheses manipulation library";
    license = lib.licenses.mit;
  };
}
