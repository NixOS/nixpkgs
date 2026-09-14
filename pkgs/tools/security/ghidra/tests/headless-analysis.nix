{
  runCommandCC,
  ghidra,
}:

runCommandCC "ghidra-headless-analysis-test"
  {
    nativeBuildInputs = [ ghidra ];
    meta = {
      description = "Import, analyse and decompile a native binary with headless Ghidra";
      inherit (ghidra.meta) maintainers;
    };
  }
  ''
    export HOME="$TMPDIR"
    # Java does not consistently derive user.home from HOME (notably on
    # Darwin), and Ghidra persists its selected JDK below user.home.
    export JAVA_TOOL_OPTIONS="-Duser.home=$HOME"

    # A tiny host-native program with a distinctive symbol to look for after
    # analysis. Building it here means the binary matches the platform Ghidra was
    # built for, so on aarch64-darwin this analyses an arm64 Mach-O.
    cat > marker.c <<'EOF'
    int nix_ghidra_marker(int a, int b) { return a * b + 7; }
    int main(void) { return nix_ghidra_marker(3, 4); }
    EOF
    $CC -O0 -o marker marker.c

    mkdir -p scripts project
    cp ${./CheckAnalysis.java} scripts/CheckAnalysis.java

    # Import with default analysis, then run the post-script. analyzeHeadless is
    # noisy and its exit status is unreliable, so assert on the NIX_TEST_*
    # markers rather than on $?. GhidraScript.println prefixes its output, so
    # match the markers anywhere on the line rather than anchoring.
    ghidra-analyzeHeadless project ghidra-test \
      -import ./marker \
      -scriptPath ./scripts \
      -postScript CheckAnalysis.java \
      -deleteProject \
      2>&1 | tee analysis.log

    field() { grep -oE "$1=[^ ]+" analysis.log | tail -1 | cut -d= -f2; }
    arch=$(field NIX_TEST_ARCH)
    instrs=$(field NIX_TEST_INSTRS)
    marker=$(field NIX_TEST_HASMARKER)
    declen=$(field NIX_TEST_DECOMPILED_LEN)

    echo "language=$arch instructions=$instrs marker=$marker decompiled_len=$declen"

    [[ -n "$instrs" && "$instrs" -gt 0 ]] \
      || { echo "FAIL: no instructions were disassembled"; exit 1; }
    [[ "$marker" == "1" ]] \
      || { echo "FAIL: nix_ghidra_marker not recovered by analysis"; exit 1; }
    [[ -n "$declen" && "$declen" -gt 0 ]] \
      || { echo "FAIL: decompiler produced no output (native decompiler broken?)"; exit 1; }

    touch "$out"
  ''
