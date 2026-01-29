{
  stdenv,
  callPackage,
  # nix tooling and utilities
  darwin,
  lib,
  fetchzip,
  makeWrapper,
  replaceVars,
  # native build inputs
  runtimeShell,
  zip,
  unzip,
  bash,
  coreutils,
  which,
  gawk,
  gnused,
  gnutar,
  gnugrep,
  gzip,
  findutils,
  diffutils,
  gnupatch,
  file,
  installShellFiles,
  python3,
  # Apple dependencies
  cctools,
  # Allow to independently override the jdks used to build and run respectively
  jdk_headless,
  majorVersion ? "8",
}:

let
  inherit (stdenv.hostPlatform) isDarwin isAarch64;

  defaultShellUtils =
    # Keep this list conservative. For more exotic tools, prefer to use
    # @rules_nixpkgs to pull in tools from the nix repository. Example:
    #
    # WORKSPACE:
    #
    #     nixpkgs_git_repository(
    #         name = "nixpkgs",
    #         revision = "def5124ec8367efdba95a99523dd06d918cb0ae8",
    #     )
    #
    #     # This defines an external Bazel workspace.
    #     nixpkgs_package(
    #         name = "bison",
    #         repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
    #     )
    #
    # some/BUILD.bazel:
    #
    #     genrule(
    #        ...
    #        cmd = "$(location @bison//:bin/bison) -other -args",
    #        tools = [
    #            ...
    #            "@bison//:bin/bison",
    #        ],
    #     )
    [
      bash
      coreutils
      diffutils
      file
      findutils
      gawk
      gnugrep
      gnupatch
      gnused
      gnutar
      gzip
      unzip
      which
      zip
    ];
  defaultShell = callPackage ./defaultShell.nix { } { inherit defaultShellUtils; };

  versionInfo = (import ./versions.nix) {
    inherit stdenv;
    inherit coreutils;
    inherit replaceVars;
    inherit majorVersion;
    inherit defaultShell;
    inherit jdk_headless;
    inherit (callPackage ./build-support/patching.nix { }) addFilePatch;
  };
  version = versionInfo.version;

  bazelSystem = if isDarwin then "darwin" else "linux";

  # on aarch64 Darwin, `uname -m` returns "arm64"
  bazelArch = if isDarwin && isAarch64 then "arm64" else stdenv.hostPlatform.parsed.cpu.name;

  src = fetchzip {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    hash = versionInfo.hash;
    stripRoot = false;
  };

  commandArgs = [
    "--nobuild_python_zip"
    "--features=-module_maps"
    "--host_features=-module_maps"
    "--announce_rc"
    "--verbose_failures"
    "--curses=no"
  ]
  ++ lib.optionals isDarwin [
    "--macos_sdk_version=${stdenv.hostPlatform.darwinMinVersion}"
    "--action_env=NIX_CFLAGS_COMPILE_${stdenv.cc.suffixSalt}"
  ];

  extraCflags = lib.optionals isDarwin [
    "-isystem ${lib.getDev darwin.libresolv}/include"
    "-isystem ${lib.getDev stdenv.cc.libcxx}/include/c++/v1"
  ];
in
stdenv.mkDerivation rec {
  pname = "bazel";
  inherit version src;

  darwinPatches = versionInfo.darwinPatches;
  patches = lib.optionals isDarwin darwinPatches ++ versionInfo.patches;

  meta = {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.bazel ];
    mainProgram = "bazel";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

  nativeBuildInputs = [
    makeWrapper
    jdk_headless
    python3
    unzip
    which

    # Shell completion
    installShellFiles
    python3.pkgs.absl-py # Needed to build fish completion
  ]
  # Needed for execlog
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) stdenv.cc
  ++ lib.optional (stdenv.hostPlatform.isDarwin) cctools.libtool;

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)

    # If EMBED_LABEL isn't set, it'd be auto-detected from CHANGELOG.md
    # and `git rev-parse --short HEAD` which would result in
    # "3.7.0- (@non-git)" due to non-git build and incomplete changelog.
    # Actual bazel releases use scripts/release/common.sh which is based
    # on branch/tag information which we don't have with tarball releases.
    # Note that .bazelversion is always correct and is based on bazel-*
    # executable name, version checks should work fine
    export EMBED_LABEL="${version}- (@non-git)"

    echo "Stage 1 - Running bazel bootstrap script"
    # Note: can't use lib.escapeShellArgs here because it will escape arguments
    #       with = using single quotes. This is fine for command invocations,
    #       but for string variable they become literal single quote chars,
    #       compile.sh will not unquote them either and command will be invalid.
    export EXTRA_BAZEL_ARGS="${lib.strings.concatStringsSep " " commandArgs}"
    export NIX_CFLAGS_COMPILE_${stdenv.cc.suffixSalt}="${lib.strings.concatStringsSep " " extraCflags}"


    ${bash}/bin/bash ./compile.sh

    # XXX: get rid of this, or move it to another stage.
    # It is plain annoying when builds fail.
    echo "Stage 2 - Generate bazel completions"
    ${bash}/bin/bash ./scripts/generate_bash_completion.sh \
        --bazel=./output/bazel \
        --output=./output/bazel-complete.bash \
        --prepend=./scripts/bazel-complete-header.bash \
        --prepend=./scripts/bazel-complete-template.bash
    ${python3}/bin/python3 ./scripts/generate_fish_completion.py \
        --bazel=./output/bazel \
        --output=./output/bazel-complete.fish

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Bazel binary contains zip archive, which contains text files and a jar
    # both of which can have store references that might be obscured to Nix
    # builder in packaged form, so we unpack and extract those references

    # Note: grep isn't necessarily 100% accurate, other approaches could be
    #       to disassemble Jar (slow) or hardcode known references
    mkdir -p $out/nix-support
    INSTALL_BASE=$(./output/bazel --batch info install_base)
    find "$INSTALL_BASE" -type f -exec \
       ${gnugrep}/bin/grep --text --only-matching --no-filename "$NIX_STORE/[^/]*" '{}' \; \
    | sort -u >> $out/nix-support/depends

    mkdir -p $out/bin

    # official wrapper scripts that searches for $WORKSPACE_ROOT/tools/bazel if
    # it can’t find something in tools, it calls
    # $out/bin/bazel-{version}-{os_arch} The binary _must_ exist with this
    # naming if your project contains a .bazelversion file.
    cp ./scripts/packages/bazel.sh $out/bin/bazel
    versioned_bazel="$out/bin/bazel-${version}-${bazelSystem}-${bazelArch}"
    mv ./output/bazel "$versioned_bazel"
    wrapProgram "$versioned_bazel" --suffix PATH : ${defaultShell.defaultShellPath}

    mkdir $out/share
    cp ./output/parser_deploy.jar $out/share/parser_deploy.jar
    substitute ${./bazel-execlog.sh} $out/bin/bazel-execlog \
      --subst-var out \
      --subst-var-by runtimeShell ${runtimeShell} \
      --subst-var-by binJava ${jdk_headless}/bin/java
    chmod +x $out/bin/bazel-execlog

    # shell completion files
    installShellCompletion --bash \
      --name bazel.bash \
      ./output/bazel-complete.bash
    installShellCompletion --zsh \
      --name _bazel \
      ./scripts/zsh_completion/_bazel
    installShellCompletion --fish \
      --name bazel.fish \
      ./output/bazel-complete.fish
  '';

  postFixup =
    # verify that bazel binary still works post-fixup
    ''
      USE_BAZEL_VERSION=${version} $out/bin/bazel --batch info release
    '';

  # Bazel binary includes zip archive at the end that `strip` would end up discarding
  stripExclude = [ "bin/.bazel-${version}-*-wrapped" ];

  passthru = {
    tests = {
      inherit (callPackage (versionInfo.injectPackage ./examples.nix) { })
        cpp
        java
        rust
        ;
    };
  };
}
