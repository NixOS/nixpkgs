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
  pname = "finmap";
  owner = "math-comp";
  inherit version;
  defaultVersion =
    let
      case = rocq: mc: out: {
        cases = [
          rocq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ rocq-core.rocq-version mathcomp-boot.version ]
      [
        (case (range "9.0" "9.1") (range "2.3" "2.5") "2.2.3")
      ]
      null;
  release = {
    "2.2.3".sha256 = "sha256-zqfMFEyD8RBJbElRjr8nGUx4JCAn5t5Jl0x+gbEuOTU=";
  };

  propagatedBuildInputs = [ mathcomp-boot ];

  meta = {
    description = "Finset and finmap library";
    license = lib.licenses.cecill-b;
  };
}
