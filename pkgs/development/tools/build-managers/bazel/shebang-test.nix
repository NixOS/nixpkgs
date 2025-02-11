{
  bazel,
  bazelTest,
  extracted,
  ripgrep,
  runLocal,
  unzip,
  ...
}:

# Tests that all shebangs are patched appropriately.
# #!/usr/bin/... should be replaced by Nix store references.
# #!.../bin/env python should be replaced by Nix store reference to the python interpreter.

let

  workspaceDir = runLocal "our_workspace" { } "mkdir $out";

  testBazel = bazelTest {
    name = "bazel-test-shebangs";
    inherit workspaceDir;
    bazelPkg = bazel;
    bazelScript = ''
      set -ueo pipefail
      FAIL=
      check_shebangs() {
        local dir="$1"
        { rg -e '#!/usr/bin' -e '#![^[:space:]]*/bin/env' $dir -e && echo && FAIL=1; } || true
      }
      extract() {
        local dir="$1"
        find "$dir" -type f '(' -name '*.zip' -or -name '*.jar' ')' -print0 \
        | while IFS="" read -r -d "" zip ; do
          echo "Extracting $zip"
          local unzipped="$zip-UNPACKED"
          mkdir -p "$unzipped"
          unzip -qq $zip -d "$unzipped"
          extract "$unzipped"
          rm -rf "$unzipped" "$zip" || true
        done
        check_shebangs "$dir"
      }

      mkdir install_root
      cp --no-preserve=all -r ${extracted bazel}/install/*/* install_root/
      extract ./install_root

      if [[ $FAIL = 1 ]]; then
        echo "Found files in the bazel distribution with illegal shebangs." >&2
        echo "Replace those by explicit Nix store paths." >&2
        echo "Python scripts should not use \`bin/env python' but the Python interpreter's store path." >&2
        exit 1
      fi
    '';
    buildInputs = [
      unzip
      ripgrep
    ];
  };

in
testBazel
