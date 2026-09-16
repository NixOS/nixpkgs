{
  lib,
  pkgs,
  nixpkgsFun,
}:
let
  check =
    crossSystem:
    let
      p = nixpkgsFun {
        localSystem = "x86_64-linux";
        inherit crossSystem;
        overlays = [
          (final: _: {
            graphMarker = "original";
            rawGraph = final;
            rawShallow = final // {
              graphMarker = "override";
            };
            completedGraph = final.pkgs;
            completedShallow = final.pkgs // {
              graphMarker = "override";
              # A shallow override is explicit; the completed graph does not
              # automatically splice newly inserted raw derivations.
              extra = final.hello;
            };
            completedWithoutHello = builtins.removeAttrs final.pkgs [ "hello" ];
          })
        ];
      };
      nativeInput =
        input:
        builtins.head
          (p.stdenv.mkDerivation {
            name = "nested-package-graph-consumer";
            nativeBuildInputs = [ input ];
            buildCommand = "touch $out";
          }).nativeBuildInputs;
    in
    assert (nativeInput p.rawGraph.hello).drvPath == p.pkgsBuildHost.hello.drvPath;
    assert (nativeInput p.completedGraph.pkgsBuildHost.hello).drvPath == p.pkgsBuildHost.hello.drvPath;
    assert p.rawShallow.graphMarker == "override";
    assert p.completedShallow.graphMarker == "override";
    assert p.completedShallow.extra.drvPath == p.pkgsHostTarget.hello.drvPath;
    assert !(p.completedShallow.extra ? __spliced);
    assert !(p.completedWithoutHello ? hello);
    true;
in
assert check null;
assert check "aarch64-linux";
pkgs.emptyFile
