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
  version = "0.0-2472-ga80124e1";

  # These environment variables are read in bazel/build-version.py to create
  # a build string. Otherwise it would attempt to extract it from .git/.
  GIT_DATE = "2022-10-21";
  GIT_VERSION = version;

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "v${version}";
    sha256 = "sha256:0jpdxqhnawrl80pbc8544pyggdp5s3cbc7byc423d5v0sri2f96v";
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
      aarch64-linux = "sha256-6Udp7sZKGU8gcy6+5WPhkSWunf1sVkha8l5S1UQsC04=";
      x86_64-linux = "sha256-WfhgbJFaM/ipdd1dRjPeVZ1mK2hotb0wLmKjO7e+BO4=";
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
      common/parser/move_yacc_stack_symbols.sh \
      common/parser/record_syntax_error.sh \
      common/tools/patch_tool_test.sh \
      common/tools/verible-transform-interactive.sh \
      common/tools/verible-transform-interactive-test.sh \
      common/util/create_version_header.sh \
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
