{ lib, pkg-config, pkg-configPackages, runCommand }:
let
  allTests = lib.mapAttrs (k: v: if v == null then null else makePkgConfigTest k v) pkg-configPackages;

  # nix-build rejects attribute names with periods
  # This will build those regardless.
  tests-combined = runCommand "pkg-config-checks" {
    allTests = lib.attrValues allTests;
  } ''
    touch $out
  '';

  makePkgConfigTest = moduleName: pkg: runCommand "check-pkg-config-${moduleName}" {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ pkg ];
    inherit moduleName;
  } ''
    echo "checking pkg-config module $moduleName in $buildInputs"
    set +e
    version="$(pkg-config --modversion $moduleName)"
    r=$?
    set -e
    if [[ $r = 0 ]]; then
      echo "✅ pkg-config module $moduleName exists and has version $version"
      echo "$version" > $out
    else
      echo "These modules were available in the input propagation closure:"
      pkg-config --list-all
      echo "❌ pkg-config module $moduleName was not found"
      false
    fi
  '';
in
  allTests // { inherit tests-combined; }
