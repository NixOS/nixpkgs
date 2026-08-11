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
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.3") "0.3.1")
    ] null;

  release."0.3.0".sha256 = "sha256-W2eenv5Q421eVn2ubbninFmmdT875f3w/Zs7yGHUKP4=";
  release."0.3.1".sha256 = "sha256-t7nHpHl6E3iXkhMO0A53URmKVpWENjf/VODVXjD9Y1A=";

  propagatedBuildInputs = [ stdlib ];

  releaseRev = v: "v${v}";

  meta = {
    description = "Total parser combinators in Rocq";
    maintainers = with lib.maintainers; [ womeier ];
    license = lib.licenses.mit;
  };
}
