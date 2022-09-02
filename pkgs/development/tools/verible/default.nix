{ lib
, stdenv
, fetchFromGitHub
, buildBazelPackage
, bazel_4
, flex
, bison
, python3
}:

buildBazelPackage rec {
  pname = "verible";
  version = "0.0-2172-g238b6df6";

  # These environment variables are read in bazel/build-version.py to create
  # a build string. Otherwise it would attempt to extract it from .git/.
  GIT_DATE = "2022-08-08";
  GIT_VERSION = version;

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "v${version}";
    sha256 = "sha256-iOJhdbipuqqBiYGgk95d1c8bEK6Z16l16GuzYCQRc2g=";
  };

  patches = [
    # Patch WORKSPACE file to not include windows-related dependencies,
    # as they are removed by bazel, breaking the fixed output derivation
    # TODO: fix upstream
    ./remove-unused-deps.patch
  ];

  bazelFlags = [ "--//bazel:use_local_flex_bison" ];

  fetchAttrs = {
    # Fixed output derivation hash after bazel fetch
    sha256 = "sha256-XoLdlEeoDJlyWlnXZADHOKu06zKHgHJfgey8UhOt+LM=";
  };

  nativeBuildInputs = [
    flex       # We use local flex and bison as WORKSPACE sources fail
    bison      # .. to compile with newer glibc
    python3
  ];

  postPatch = ''
    patchShebangs bazel/build-version.py \
      common/util/create_version_header.sh \
      common/parser/move_yacc_stack_symbols.sh \
      common/parser/record_syntax_error.sh
  '';

  removeRulesCC = false;
  bazelTarget = ":install-binaries";
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
    maintainers = with maintainers; [ hzeller ];
  };
}
