{
  bazel
, bazelTest
, distDir
, extracted
, runLocal
, unzip
}:

# Tests that all shebangs are patched appropriately.
# #!/usr/bin/... should be replaced by Nix store references.
# #!.../bin/env python should be replaced by Nix store reference to the python interpreter.

let

  workspaceDir = runLocal "our_workspace" {} "mkdir $out";

  testBazel = bazelTest {
    name = "bazel-test-shebangs";
    inherit workspaceDir;
    bazelPkg = bazel;
    bazelScript = ''
      set -ueo pipefail
      FAIL=
      check_shebangs() {
        local dir="$1"
        { grep -Re '#!/usr/bin' $dir && FAIL=1; } || true
        { grep -Re '#![^[:space:]]*/bin/env' $dir && FAIL=1; } || true
      }
      BAZEL_EXTRACTED=${extracted bazel}/install
      check_shebangs $BAZEL_EXTRACTED
      while IFS= read -r -d "" zip; do
        unzipped="./$zip/UNPACKED"
        mkdir -p "$unzipped"
        unzip -qq $zip -d "$unzipped"
        check_shebangs "$unzipped"
        rm -rf unzipped
      done < <(find $BAZEL_EXTRACTED -type f -name '*.zip' -or -name '*.jar' -print0)
      if [[ $FAIL = 1 ]]; then
        echo "Found files in the bazel distribution with illegal shebangs." >&2
        echo "Replace those by explicit Nix store paths." >&2
        echo "Python scripts should not use \`bin/env python' but the Python interpreter's store path." >&2
        exit 1
      fi
    '';
    buildInputs = [ unzip ];
  };

in testBazel
