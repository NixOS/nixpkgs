{
  lib,
  mkRocqDerivation,
  stdlib,
  rocq-core,
  version ? null,
}:

let
  derivation = mkRocqDerivation {
    pname = "parseque";
    repo = "parseque";
    owner = "rocq-community";

    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      lib.switch rocq-core.rocq-version [
        (case (lib.versions.range "9.0" "9.3") "0.3.1")
        (case (lib.versions.range "8.16" "8.20") "0.2.2")
      ] null;

    release."0.2.2".hash = "sha256-O50Rs7Yf1H4wgwb7ltRxW+7IF0b04zpfs+mR83rxT+E=";
    release."0.3.0".sha256 = "sha256-W2eenv5Q421eVn2ubbninFmmdT875f3w/Zs7yGHUKP4=";
    release."0.3.1".sha256 = "sha256-t7nHpHl6E3iXkhMO0A53URmKVpWENjf/VODVXjD9Y1A=";

    propagatedBuildInputs = [ stdlib ];

    releaseRev = v: "v${v}";

    useCoqifVersion = v: v != null && v != "dev" && lib.versions.isLe "0.2.2" v;

    meta = {
      description = "Total parser combinators in Rocq";
      maintainers = with lib.maintainers; [ womeier ];
      license = lib.licenses.mit;
    };
  };
in
derivation
