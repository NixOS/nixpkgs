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
      with lib.versions;
      lib.switch rocq-core.rocq-version (lib.lists.sort (x: y: isLe x.out y.out) (
        lib.mapAttrsToList (out: case: { inherit case out; }) {
          "1.9.1" = range "9.0" "9.0";
        }
      )) null;
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
