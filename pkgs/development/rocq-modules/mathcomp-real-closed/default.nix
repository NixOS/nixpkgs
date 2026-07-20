{
  rocq-core,
  mkRocqDerivation,
  mathcomp,
  mathcomp-bigenough,
  lib,
  version ? null,
}:

mkRocqDerivation {

  namePrefix = [
    "rocq"
    "mathcomp"
  ];
  pname = "real-closed";
  owner = "math-comp";
  inherit version;
  release = {
    "2.0.6".sha256 = "sha256-c+0nlNTjTf115vjvnpLrgXye5YdjsWlsCBpGZj+hU9E=";
  };

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
      [ rocq-core.version mathcomp.version ]
      [
        (case (range "9.0" "9.2") (isGe "2.5.0") "2.0.6")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.field
    mathcomp-bigenough
  ];

  meta = {
    description = "Mathematical Components Library on real closed fields";
    license = lib.licenses.cecill-c;
  };
}
