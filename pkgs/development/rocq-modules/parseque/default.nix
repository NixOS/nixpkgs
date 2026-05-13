{
  lib,
  mkRocqDerivation,
  stdlib,
  rocq-core,
  version ? null,
}:

mkRocqDerivation {
  pname = "parseque";
  repo = "parseque";
  owner = "rocq-community";

  inherit version;
  defaultVersion =
    lib.switch
      [ rocq-core.rocq-version ]
      [
        {
          cases = [ (lib.versions.range "9.0" "9.2") ];
          out = "0.3.0";
        }
      ]
      null;

  release."0.3.0".sha256 = "sha256-W2eenv5Q421eVn2ubbninFmmdT875f3w/Zs7yGHUKP4=";

  propagatedBuildInputs = [ stdlib ];

  releaseRev = v: "v${v}";

  meta = {
    description = "Total parser combinators in Rocq";
    maintainers = with lib.maintainers; [ womeier ];
    license = lib.licenses.mit;
  };
}
