{
  lib,
  mkRocqDerivation,
  metarocq-utils,
  stdlib,
  rocq-core,
  version ? null,
}:

mkRocqDerivation {
  pname = "base64";
  owner = "womeier";
  repo = "rocq-base64";

  inherit version;
  defaultVersion =
    let
      case = rocq: mr: out: {
        cases = [
          rocq
          mr
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [
        rocq-core.rocq-version
        metarocq-utils.version
      ]
      [
        (case (range "9.0" "9.3") (isGe "1.4") "0.1.1")
      ]
      null;

  release."0.1.1".hash = "sha256-fx2XjmZVXSBAREHBBiFHaKSl89/24a8vG4eEMiQu6g8=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    stdlib
    metarocq-utils
    rocq-core.ocamlPackages.findlib
  ];

  meta = {
    description = "Verified base64 encoding and decoding in Rocq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ womeier ];
  };
}
