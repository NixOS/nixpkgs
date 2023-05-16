{ lib
, stdenv
<<<<<<< HEAD
, buildBazelPackage
, fetchFromGitHub
, bazel_4
, bison
, flex
=======
, fetchFromGitHub
, buildBazelPackage
, bazel_4
, flex
, bison
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  GIT_DATE = "2023-08-29";
  GIT_VERSION = "v0.0-3410-g398a8505";
=======
  GIT_DATE = "2023-04-14";
  GIT_VERSION = "v0.0-3179-g525ffaf7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Derive nix package version from GIT_VERSION: "v1.2-345-abcde" -> "1.2.345"
  version = builtins.concatStringsSep "." (lib.take 3 (lib.drop 1 (builtins.splitVersion GIT_VERSION)));

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "${GIT_VERSION}";
<<<<<<< HEAD
    sha256 = "sha256-qi//Dssgg5ITrL5jCpZXpSrhSm2xCqe53D9ctK7SQoU=";
=======
    sha256 = "sha256-IXS8yeyryBNpPkCpMcOUsdIlKo447d0a8aZKroFJOzM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Patch WORKSPACE file to not include windows-related dependencies,
    # as they are removed by bazel, breaking the fixed output derivation
    # TODO: fix upstream
    ./remove-unused-deps.patch
  ];

<<<<<<< HEAD
  bazel = bazel_4;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      aarch64-linux = "sha256-Hf/jF5Y7QS2ZNFmSx2LIb0b6gdjditE97HwWGqQJac8=";
      x86_64-linux = "sha256-WBp5Fi5vvKLVgRWvQ3VB7sY6ySpbwCdhU5KqZH9sLy4=";
=======
      aarch64-linux = "sha256-BrJyFeq3BB4sHIXMMxRIaYV+VJAfTs2bvK7pnw6faBY=";
      x86_64-linux = "sha256-G6tqHWeQBi2Ph3IDFNu2sp+UU2BO93+lcyJ+kvpuRJo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    }.${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    bison      # We use local flex and bison as WORKSPACE sources fail
    flex       # .. to compile with newer glibc
=======
    flex       # We use local flex and bison as WORKSPACE sources fail
    bison      # .. to compile with newer glibc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  bazel = bazel_4;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  removeRulesCC = false;
  bazelTargets = [ ":install-binaries" ];
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
<<<<<<< HEAD
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server.";
    homepage = "https://github.com/chipsalliance/verible";
    license = licenses.asl20;
    maintainers = with maintainers; [ hzeller newam ];
    platforms = platforms.linux;
=======
    homepage = "https://github.com/chipsalliance/verible";
    description = "Suite of SystemVerilog developer tools. Including a style-linter, indexer, formatter, and language server.";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hzeller newam ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
