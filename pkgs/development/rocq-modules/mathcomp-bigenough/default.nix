{
  rocq-core,
  mkRocqDerivation,
  mathcomp-boot,
  lib,
  version ? null,
}:

mkRocqDerivation {

  namePrefix = [
    "rocq-core"
    "mathcomp"
  ];
  pname = "bigenough";
  owner = "math-comp";

  release = {
    "1.0.4".sha256 = "sha256-cwfDCEFSXWnqV5aIrhTviUti0CXNwmFe6zVbqlD2iZw=";
  };
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.1") "1.0.4")
    ] null;

  propagatedBuildInputs = [ mathcomp-boot ];

  meta = {
    description = "Small library to do epsilon - N reasonning";
    license = lib.licenses.cecill-b;
  };
}
