{ lib
, stdenv
, fetchFromGitHub
, buildBazelPackage
, bazel_4
, flex
, bison
, python3
}:

let
  system = stdenv.hostPlatform.system;
in
buildBazelPackage rec {
  pname = "verible";

  # These environment variables are read in bazel/build-version.py to create
  # a build string shown in the tools --version output.
  # If env variables not set, it would attempt to extract it from .git/.
  GIT_DATE = "2023-02-02";
  GIT_VERSION = "v0.0-2821-gb2180bfa";

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION)));

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "${GIT_VERSION}";
    sha256 = "sha256-etcimvInhebH2zRPyZnWUq6m3VnCq44w32GJrIacULo=";
  };

  patches = [
    # Patch WORKSPACE file to not include windows-related dependencies,
    # as they are removed by bazel, breaking the fixed output derivation
    # TODO: fix upstream
    ./remove-unused-deps.patch
  ];

  bazelFlags = [
    "--//bazel:use_local_flex_bison"
    "--javabase=@bazel_tools//tools/jdk:remote_jdk11"
    "--host_javabase=@bazel_tools//tools/jdk:remote_jdk11"
  ];

  fetchAttrs = {
    # Fixed output derivation hash after bazel fetch.
    # This varies per platform, probably from the JDK pulled in being part
    # of the output derivation ? Is there a more robust way to do this ?
    # (Hashes extracted from the ofborg build logs)
    sha256 = {
      aarch64-linux = "sha256-dYJoae3+u+gpULHS8nteFzzL974cVJ+cJzeG/Dz2HaQ=";
      x86_64-linux = "sha256-Jd99+nhqgZ2Gwd78eyXfnSSfbl8C3hoWkiUnzJG1jqM=";
    }.${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    flex       # We use local flex and bison as WORKSPACE sources fail
    bison      # .. to compile with newer glibc
    python3
  ];

  postPatch = ''
    patchShebangs\
      bazel/build-version.py \
      bazel/sh_test_with_runfiles_lib.sh \
      common/lsp/dummy-ls_test.sh \
      common/tools/patch_tool_test.sh \
      common/tools/verible-transform-interactive.sh \
      common/tools/verible-transform-interactive-test.sh \
      kythe-browse.sh \
      verilog/tools
  '';

  bazel = bazel_4;
  removeRulesCC = false;
  bazelTarget = ":install-binaries";
  bazelTestTargets = [ "//..." ];
  bazelBuildFlags = [
    "-c opt"
  ];
  buildAttrs = {
    installPhase = ''
      mkdir -p "$out/bin"

      install bazel-bin/common/tools/verible-patch-tool "$out/bin"

      V_TOOLS_DIR=bazel-bin/verilog/tools
      install $V_TOOLS_DIR/diff/verible-verilog-diff "$out/bin"
      install $V_TOOLS_DIR/formatter/verible-verilog-format "$out/bin"
      install $V_TOOLS_DIR/kythe/verible-verilog-kythe-extractor "$out/bin"
      install $V_TOOLS_DIR/lint/verible-verilog-lint "$out/bin"
      install $V_TOOLS_DIR/ls/verible-verilog-ls "$out/bin"
      install $V_TOOLS_DIR/obfuscator/verible-verilog-obfuscate "$out/bin"
      install $V_TOOLS_DIR/preprocessor/verible-verilog-preprocessor "$out/bin"
      install $V_TOOLS_DIR/project/verible-verilog-project "$out/bin"
      install $V_TOOLS_DIR/syntax/verible-verilog-syntax "$out/bin"
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/chipsalliance/verible";
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server.";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hzeller newam ];
  };
}
