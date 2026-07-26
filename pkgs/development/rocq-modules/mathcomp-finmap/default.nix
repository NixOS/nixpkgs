{
  rocq-core,
  mkRocqDerivation,
  mathcomp-boot,
  lib,
  version ? null,
}:

mkRocqDerivation {

  namePrefix = [
    "rocq"
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
        (case (range "9.2" "9.3") (range "2.5" "2.6") "2.2.4") # also compiles on Rocq 9.0 and 9.1 (but requires graph-theory update)
        (case (range "9.0" "9.1") (range "2.3" "2.5") "2.2.2")
      ]
      null;
  release = {
    "2.2.4".sha256 = "sha256-sEok7UhXiPdIH8/wzvVhXg1yprCETVmxMzeFRHh6Tug=";
    "2.2.2".sha256 = "sha256-G5fSdx4MhOXtQ2H8lpyK5FuIbWAZNc7vRL3hcYmGA2o=";
  };

  propagatedBuildInputs = [ mathcomp-boot ];

  meta = {
    description = "Finset and finmap library";
    license = lib.licenses.cecill-b;
  };
}
