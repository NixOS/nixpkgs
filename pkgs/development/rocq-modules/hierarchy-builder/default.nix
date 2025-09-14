{
  lib,
  mkRocqDerivation,
  rocq-core,
  rocq-elpi,
  version ? null,
}:

let
  hb = mkRocqDerivation {
    pname = "hierarchy-builder";
    owner = "math-comp";
    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch rocq-core.rocq-version [
        (case (range "9.0" "9.1") "1.10.0")
        (case (range "9.0" "9.1") "1.9.1")
      ] null;
    release."1.10.0".sha256 = "sha256-c52nS8I0tia7Q8lZTFJyHVPVabW9xv55m7w6B7y3+e8=";
    release."1.9.1".sha256 = "sha256-AiS0ezMyfIYlXnuNsVLz1GlKQZzJX+ilkrKkbo0GrF0=";
    releaseRev = v: "v${v}";

    propagatedBuildInputs = [ rocq-elpi ];

    meta = with lib; {
      description = "High level commands to declare a hierarchy based on packed classes";
      maintainers = with maintainers; [
        cohencyril
        siraben
      ];
      license = licenses.mit;
    };
  };
in
hb.overrideAttrs (
  o:
  lib.optionalAttrs (o.version == "1.9.1") { installFlags = [ "DESTDIR=$(out)" ] ++ o.installFlags; }
)
