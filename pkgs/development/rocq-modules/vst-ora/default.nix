{
  lib,
  mkRocqDerivation,
  iris,
  version ? null,
}:

mkRocqDerivation {
  pname = "vst-ora";
  owner = "mansky1";
  repo = "ora";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch iris.version [
      (case (isEq "4.5.0") "1.2.1")
    ] null;
  release."1.2.1".hash = "sha256-o6+BnqYe3JA0VVWRNw9yhYKsoPm1Xjjx71pNdLQ1U6M=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ iris ];

  meta = {
    description = "Ordered Resource Algebras for Iris, as used by VST";
    longDescription = ''
      The Ordered Resource Algebra (ORA) logic is a variant of the Iris base logic that allows use of both linear and affine resources.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
}
