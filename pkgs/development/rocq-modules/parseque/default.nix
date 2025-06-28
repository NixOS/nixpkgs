{
  lib,
  mkRocqDerivation,
  which,
  stdlib,
  rocq-core,
  version ? null,
}:

with lib;
mkRocqDerivation {
  pname = "parseque";
  repo = "parseque";
  owner = "rocq-community";

  inherit version;
  defaultVersion =
    with versions;
    switch
      [ rocq-core.rocq-version ]
      [
        {
          cases = [ (range "9.0" "9.0") ];
          out = "0.3.0";
        }
      ]
      null;

  release."0.3.0".sha256 = "sha256-W2eenv5Q421eVn2ubbninFmmdT875f3w/Zs7yGHUKP4=";

  propagatedBuildInputs = [ stdlib ];

  releaseRev = v: "v${v}";

  meta = {
    description = "Total parser combinators in Rocq";
    maintainers = with maintainers; [ womeier ];
    license = licenses.mit;
  };
}
