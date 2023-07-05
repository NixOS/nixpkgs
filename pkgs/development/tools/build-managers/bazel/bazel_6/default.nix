{ stdenv, callPackage, lib, fetchurl, fetchpatch, fetchFromGitHub, installShellFiles
, runCommand, runCommandCC, makeWrapper, recurseIntoAttrs
# this package (through the fixpoint glass)
, bazel_self
, lr, xe, zip, unzip, bash, writeCBin, coreutils
, which, gawk, gnused, gnutar, gnugrep, gzip, findutils
# updater
, python3, writeScript
# Apple dependencies
, cctools, libcxx, CoreFoundation, CoreServices, Foundation
# Allow to independently override the jdks used to build and run respectively
, buildJdk, runJdk
, runtimeShell
# Downstream packages for tests
, bazel-watcher
# Always assume all markers valid (this is needed because we remove markers; they are non-deterministic).
# Also, don't clean up environment variables (so that NIX_ environment variables are passed to compilers).
, enableNixHacks ? false
, gcc-unwrapped
, autoPatchelfHook
, file
, substituteAll
, writeTextFile
}:

let
  version = "6.2.0";
  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    hash = "sha256-8ej3iGN6xXTUcdYZ0glrqsoEoZtXoDQ5ngeWM9tEGUU=";
  };

  # Update with
  # 1. export BAZEL_SELF=$(nix-build -A bazel_6)
  # 2. update version and hash for sources above
  # 3. `eval $(nix-build -A bazel_6.updater)`
  # 4. add new dependencies from the dict in ./src-deps.json if required by failing build
  srcDeps = lib.attrsets.attrValues srcDepsSet;
  srcDepsSet =
    let
      srcs = lib.importJSON ./src-deps.json;
      toFetchurl = d: lib.attrsets.nameValuePair d.name (fetchurl {
        urls = d.urls or [d.url];
        sha256 = d.sha256;
      });
    in builtins.listToAttrs (map toFetchurl [
      srcs.desugar_jdk_libs
      srcs.io_bazel_skydoc
      srcs.bazel_skylib
      srcs.bazelci_rules
      srcs.io_bazel_rules_sass
      srcs.platforms
      srcs.remote_java_tools_for_testing
      srcs."coverage_output_generator-v2.6.zip"
      srcs.build_bazel_rules_nodejs
      srcs.android_tools_for_testing
      srcs.openjdk_linux_vanilla
      srcs.bazel_toolchains
      srcs.com_github_grpc_grpc
      srcs.upb
      srcs.com_google_protobuf
      srcs.rules_pkg
      srcs.rules_cc
      srcs.rules_java
      srcs.rules_proto
      srcs.rules_nodejs
      srcs.rules_license
      srcs.com_google_absl
      srcs.com_googlesource_code_re2
      srcs.com_github_cares_cares
      srcs.com_envoyproxy_protoc_gen_validate
      srcs.com_google_googleapis
      srcs.bazel_gazelle
    ]);

  distDir = runCommand "bazel-deps" {} ''
    mkdir -p $out
    for i in ${builtins.toString srcDeps}; do cp $i $out/$(stripHash $i); done
  '';

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
      file
      findutils
      gawk
      gnugrep
      gnused
      gnutar
      gzip
      python3
      unzip
      which
      zip
    ];

  defaultShellPath = lib.makeBinPath defaultShellUtils;

  platforms = lib.platforms.linux ++ lib.platforms.darwin;

  system = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";

  # on aarch64 Darwin, `uname -m` returns "arm64"
  arch = with stdenv.hostPlatform; if isDarwin && isAarch64 then "arm64" else parsed.cpu.name;

  bazelRC = writeTextFile {
    name = "bazel-rc";
    text = ''
      startup --server_javabase=${runJdk}

      # Can't use 'common'; https://github.com/bazelbuild/bazel/issues/3054
      # Most commands inherit from 'build' anyway.
      build --distdir=${distDir}
      fetch --distdir=${distDir}
      query --distdir=${distDir}

      build --extra_toolchains=@bazel_tools//tools/jdk:nonprebuilt_toolchain_definition
      build --tool_java_runtime_version=local_jdk_11
      build --java_runtime_version=local_jdk_11

      # load default location for the system wide configuration
      try-import /etc/bazel.bazelrc
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "bazel";
  inherit version;

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    inherit platforms;
  };

  inherit src;
  inherit sourceRoot;
  patches = [
    # Force usage of the _non_ prebuilt java toolchain.
    # the prebuilt one does not work in nix world.
    ./java_toolchain.patch

    # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
    # This is breaking the build of any C target. This patch removes the last
    # argument if it's found to be an empty string.
    ../trim-last-argument-to-gcc-if-empty.patch

    # `java_proto_library` ignores `strict_proto_deps`
    # https://github.com/bazelbuild/bazel/pull/16146
    ./strict_proto_deps.patch

    # On Darwin, using clang 6 to build fails because of a linker error (see #105573),
    # but using clang 7 fails because libarclite_macosx.a cannot be found when linking
    # the xcode_locator tool.
    # This patch removes using the -fobjc-arc compiler option and makes the code
    # compile without automatic reference counting. Caveat: this leaks memory, but
    # we accept this fact because xcode_locator is only a short-lived process used during the build.
    (substituteAll {
      src = ./no-arc.patch;
      multiBinPatch = if stdenv.hostPlatform.system == "aarch64-darwin" then "arm64" else "x86_64";
    })

    # --experimental_strict_action_env (which may one day become the default
    # see bazelbuild/bazel#2574) hardcodes the default
    # action environment to a non hermetic value (e.g. "/usr/local/bin").
    # This is non hermetic on non-nixos systems. On NixOS, bazel cannot find the required binaries.
    # So we are replacing this bazel paths by defaultShellPath,
    # improving hermeticity and making it work in nixos.
    (substituteAll {
      src = ../strict_action_env.patch;
      strictActionEnvPatch = defaultShellPath;
    })

    (substituteAll {
      src = ./actions_path.patch;
      actionsPathPatch = defaultShellPath;
    })

    # bazel reads its system bazelrc in /etc
    # override this path to a builtin one
    (substituteAll {
      src = ../bazel_rc.patch;
      bazelSystemBazelRCPath = bazelRC;
    })
  ] ++ lib.optional enableNixHacks ./nix-hacks.patch;


  # Additional tests that check bazel’s functionality. Execute
  #
  #     nix-build . -A bazel_5.tests
  #
  # in the nixpkgs checkout root to exercise them locally.
  passthru.tests =
    let
      runLocal = name: attrs: script:
      let
        attrs' = removeAttrs attrs [ "buildInputs" ];
        buildInputs = attrs.buildInputs or [];
      in
      runCommandCC name ({
        inherit buildInputs;
        preferLocalBuild = true;
        meta.platforms = platforms;
      } // attrs') script;

      # bazel wants to extract itself into $install_dir/install every time it runs,
      # so let’s do that only once.
      extracted = bazelPkg:
        let install_dir =
          # `install_base` field printed by `bazel info`, minus the hash.
          # yes, this path is kinda magic. Sorry.
          "$HOME/.cache/bazel/_bazel_nixbld";
        in runLocal "bazel-extracted-homedir" { passthru.install_dir = install_dir; } ''
            export HOME=$(mktemp -d)
            touch WORKSPACE # yeah, everything sucks
            install_base="$(${bazelPkg}/bin/bazel info | grep install_base)"
            # assert it’s actually below install_dir
            [[ "$install_base" =~ ${install_dir} ]] \
              || (echo "oh no! $install_base but we are \
            trying to copy ${install_dir} to $out instead!"; exit 1)
            cp -R ${install_dir} $out
          '';

      bazelTest = { name, bazelScript, workspaceDir, bazelPkg, buildInputs ? [] }:
        let
          be = extracted bazelPkg;
        in runLocal name { inherit buildInputs; } (
          # skip extraction caching on Darwin, because nobody knows how Darwin works
          (lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
            # set up home with pre-unpacked bazel
            export HOME=$(mktemp -d)
            mkdir -p ${be.install_dir}
            cp -R ${be}/install ${be.install_dir}

            # https://stackoverflow.com/questions/47775668/bazel-how-to-skip-corrupt-installation-on-centos6
            # Bazel checks whether the mtime of the install dir files
            # is >9 years in the future, otherwise it extracts itself again.
            # see PosixFileMTime::IsUntampered in src/main/cpp/util
            # What the hell bazel.
            ${lr}/bin/lr -0 -U ${be.install_dir} | ${xe}/bin/xe -N0 -0 touch --date="9 years 6 months" {}
          '')
          +
          ''
            # Note https://github.com/bazelbuild/bazel/issues/5763#issuecomment-456374609
            # about why to create a subdir for the workspace.
            cp -r ${workspaceDir} wd && chmod u+w wd && cd wd

            ${bazelScript}

            touch $out
          '');

      bazelWithNixHacks = bazel_self.override { enableNixHacks = true; };

      bazel-examples = fetchFromGitHub {
        owner = "bazelbuild";
        repo = "examples";
        rev = "4183fc709c26a00366665e2d60d70521dc0b405d";
        sha256 = "1mm4awx6sa0myiz9j4hwp71rpr7yh8vihf3zm15n2ii6xb82r31k";
      };

    in (lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
      # `extracted` doesn’t work on darwin
      shebang = callPackage ../shebang-test.nix { inherit runLocal extracted bazelTest distDir; bazel = bazel_self;};
    }) // {
      bashTools = callPackage ../bash-tools-test.nix { inherit runLocal bazelTest distDir; bazel = bazel_self;};
      cpp = callPackage ../cpp-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazel_self;};
      java = callPackage ../java-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazel_self;};
      protobuf = callPackage ../protobuf-test.nix { inherit runLocal bazelTest distDir; bazel = bazel_self; };
      pythonBinPath = callPackage ../python-bin-path-test.nix { inherit runLocal bazelTest distDir; bazel = bazel_self;};

      bashToolsWithNixHacks = callPackage ../bash-tools-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };

      cppWithNixHacks = callPackage ../cpp-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazelWithNixHacks; };
      javaWithNixHacks = callPackage ../java-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazelWithNixHacks; };
      protobufWithNixHacks = callPackage ../protobuf-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };
      pythonBinPathWithNixHacks = callPackage ../python-bin-path-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };

      # downstream packages using buildBazelPackage
      # fixed-output hashes of the fetch phase need to be spot-checked manually
      downstream = recurseIntoAttrs ({
        inherit bazel-watcher;
      });
    };

  src_for_updater = stdenv.mkDerivation rec {
    name = "updater-sources";
    inherit src;
    nativeBuildInputs = [ unzip ];
    inherit sourceRoot;
    installPhase = ''
      runHook preInstall

      cp -r . "$out"

      runHook postInstall
    '';
  };
  # update the list of workspace dependencies
  passthru.updater = writeScript "update-bazel-deps.sh" ''
    #!${runtimeShell}
    (cd "${src_for_updater}" &&
        BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 \
        "$BAZEL_SELF"/bin/bazel \
            query 'kind(http_archive, //external:*) + kind(http_file, //external:*) + kind(distdir_tar, //external:*) + kind(git_repository, //external:*)' \
            --loading_phase_threads=1 \
            --output build) \
    | "${python3}"/bin/python3 "${./update-srcDeps.py}" \
      "${builtins.toString ./src-deps.json}"
  '';

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Bazel starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  postPatch = let

    darwinPatches = ''
      bazelLinkFlags () {
        eval set -- "$NIX_LDFLAGS"
        local flag
        for flag in "$@"; do
          printf ' -Wl,%s' "$flag"
        done
      }

      # Disable Bazel's Xcode toolchain detection which would configure compilers
      # and linkers from Xcode instead of from PATH
      export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

      # Explicitly configure gcov since we don't have it on Darwin, so autodetection fails
      export GCOV=${coreutils}/bin/false

      # Framework search paths aren't added by bintools hook
      # https://github.com/NixOS/nixpkgs/pull/41914
      export NIX_LDFLAGS+=" -F${CoreFoundation}/Library/Frameworks -F${CoreServices}/Library/Frameworks -F${Foundation}/Library/Frameworks"

      # libcxx includes aren't added by libcxx hook
      # https://github.com/NixOS/nixpkgs/pull/41589
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${lib.getDev libcxx}/include/c++/v1"

      # don't use system installed Xcode to run clang, use Nix clang instead
      sed -i -E "s;/usr/bin/xcrun (--sdk macosx )?clang;${stdenv.cc}/bin/clang $NIX_CFLAGS_COMPILE $(bazelLinkFlags) -framework CoreFoundation;g" \
        scripts/bootstrap/compile.sh \
        tools/osx/BUILD

      substituteInPlace scripts/bootstrap/compile.sh --replace ' -mmacosx-version-min=10.9' ""

      # nixpkgs's libSystem cannot use pthread headers directly, must import GCD headers instead
      sed -i -e "/#include <pthread\/spawn.h>/i #include <dispatch/dispatch.h>" src/main/cpp/blaze_util_darwin.cc

      # clang installed from Xcode has a compatibility wrapper that forwards
      # invocations of gcc to clang, but vanilla clang doesn't
      sed -i -e 's;_find_generic(repository_ctx, "gcc", "CC", overriden_tools);_find_generic(repository_ctx, "clang", "CC", overriden_tools);g' tools/cpp/unix_cc_configure.bzl

      sed -i -e 's;"/usr/bin/libtool";_find_generic(repository_ctx, "libtool", "LIBTOOL", overriden_tools);g' tools/cpp/unix_cc_configure.bzl
      wrappers=( tools/cpp/osx_cc_wrapper.sh.tpl )
      for wrapper in "''${wrappers[@]}"; do
        sed -i -e "s,/usr/bin/gcc,${stdenv.cc}/bin/clang,g" $wrapper
        sed -i -e "s,/usr/bin/install_name_tool,${cctools}/bin/install_name_tool,g" $wrapper
        sed -i -e "s,/usr/bin/xcrun install_name_tool,${cctools}/bin/install_name_tool,g" $wrapper
      done
    '';

    genericPatches = ''
      # md5sum is part of coreutils
      sed -i 's|/sbin/md5|md5sum|g' \
        src/BUILD third_party/ijar/test/testenv.sh tools/objc/libtool.sh

      # replace initial value of pythonShebang variable in BazelPythonSemantics.java
      substituteInPlace src/main/java/com/google/devtools/build/lib/bazel/rules/python/BazelPythonSemantics.java \
        --replace '"#!/usr/bin/env " + pythonExecutableName' "\"#!${python3}/bin/python\""

      substituteInPlace src/main/java/com/google/devtools/build/lib/starlarkbuildapi/python/PyRuntimeInfoApi.java \
        --replace '"#!/usr/bin/env python3"' "\"#!${python3}/bin/python\""

      # substituteInPlace is rather slow, so prefilter the files with grep
      grep -rlZ /bin/ src/main/java/com/google/devtools | while IFS="" read -r -d "" path; do
        # If you add more replacements here, you must change the grep above!
        # Only files containing /bin are taken into account.
        substituteInPlace "$path" \
          --replace /bin/bash ${bash}/bin/bash \
          --replace "/usr/bin/env bash" ${bash}/bin/bash \
          --replace "/usr/bin/env python" ${python3}/bin/python \
          --replace /usr/bin/env ${coreutils}/bin/env \
          --replace /bin/true ${coreutils}/bin/true
      done

      grep -rlZ /bin/ tools/python | while IFS="" read -r -d "" path; do
        substituteInPlace "$path" \
          --replace "/usr/bin/env python2" ${python3.interpreter} \
          --replace "/usr/bin/env python3" ${python3}/bin/python \
          --replace /usr/bin/env ${coreutils}/bin/env
      done

      # bazel test runner include references to /bin/bash
      substituteInPlace tools/build_rules/test_rules.bzl \
        --replace /bin/bash ${bash}/bin/bash

      for i in $(find tools/cpp/ -type f)
      do
        substituteInPlace $i \
          --replace /bin/bash ${bash}/bin/bash
      done

      # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
      substituteInPlace scripts/bootstrap/compile.sh \
          --replace /bin/bash ${bash}/bin/bash

      # add nix environment vars to .bazelrc
      cat >> .bazelrc <<EOF
      # Limit the resources Bazel is allowed to use during the build to 1/2 the
      # available RAM and 3/4 the available CPU cores. This should help avoid
      # overwhelming the build machine.
      build --toolchain_resolution_debug=".*"
      build --local_ram_resources=HOST_RAM*.5
      build --local_cpu_resources=HOST_CPUS*.75

      build --distdir=${distDir}
      fetch --distdir=${distDir}
      build --copt="$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt="/g')"
      build --host_copt="$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt="/g')"
      build --linkopt="$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --linkopt="/g')"
      build --host_linkopt="$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --host_linkopt="/g')"
      build --linkopt="-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt="-Wl,/g')"
      build --host_linkopt="-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt="-Wl,/g')"
      build --extra_toolchains=@bazel_tools//tools/jdk:nonprebuilt_toolchain_definition
      build --verbose_failures
      build --curses=no
      build --features=-layering_check
      build --experimental_strict_java_deps=off
      build --strict_proto_deps=off
      EOF

      cat >> third_party/grpc/bazel_1.41.0.patch <<EOF
      diff --git a/third_party/grpc/BUILD b/third_party/grpc/BUILD
      index 39ee9f97c6..9128d20c85 100644
      --- a/third_party/grpc/BUILD
      +++ b/third_party/grpc/BUILD
      @@ -28,7 +28,6 @@ licenses(["notice"])
       package(
           default_visibility = ["//visibility:public"],
           features = [
      -        "layering_check",
               "-parse_headers",
           ],
       )
      EOF

      # add the same environment vars to compile.sh
      sed -e "/\$command \\\\$/a --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --linkopt=\"$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --linkopt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_linkopt=\"$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --host_linkopt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\" \\\\" \
          -e "/\$command \\\\$/a --tool_java_runtime_version=local_jdk_11 \\\\" \
          -e "/\$command \\\\$/a --java_runtime_version=local_jdk_11 \\\\" \
          -e "/\$command \\\\$/a --verbose_failures \\\\" \
          -e "/\$command \\\\$/a --curses=no \\\\" \
          -e "/\$command \\\\$/a --features=-layering_check \\\\" \
          -e "/\$command \\\\$/a --experimental_strict_java_deps=off \\\\" \
          -e "/\$command \\\\$/a --strict_proto_deps=off \\\\" \
          -i scripts/bootstrap/compile.sh

      # This is necessary to avoid:
      # "error: no visible @interface for 'NSDictionary' declares the selector
      # 'initWithContentsOfURL:error:'"
      # This can be removed when the apple_sdk is upgraded beyond 10.13+
      sed -i '/initWithContentsOfURL:versionPlistUrl/ {
        N
        s/error:nil\];/\];/
      }' tools/osx/xcode_locator.m

      # append the PATH with defaultShellPath in tools/bash/runfiles/runfiles.bash
      echo "PATH=\$PATH:${defaultShellPath}" >> runfiles.bash.tmp
      cat tools/bash/runfiles/runfiles.bash >> runfiles.bash.tmp
      mv runfiles.bash.tmp tools/bash/runfiles/runfiles.bash

      patchShebangs .
    '';
    in lib.optionalString stdenv.hostPlatform.isDarwin darwinPatches
     + genericPatches;

  buildInputs = [buildJdk] ++ defaultShellUtils;

  # when a command can’t be found in a bazel build, you might also
  # need to add it to `defaultShellPath`.
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    python3
    unzip
    which
    zip
    python3.pkgs.absl-py   # Needed to build fish completion
  ] ++ lib.optionals (stdenv.isDarwin) [ cctools libcxx CoreFoundation CoreServices Foundation ];

  # Bazel makes extensive use of symlinks in the WORKSPACE.
  # This causes problems with infinite symlinks if the build output is in the same location as the
  # Bazel WORKSPACE. This is why before executing the build, the source code is moved into a
  # subdirectory.
  # Failing to do this causes "infinite symlink expansion detected"
  preBuildPhases = ["preBuildPhase"];
  preBuildPhase = ''
    mkdir bazel_src
    shopt -s dotglob extglob
    mv !(bazel_src) bazel_src
  '';
  buildPhase = ''
    runHook preBuild

    # Increasing memory during compilation might be necessary.
    # export BAZEL_JAVAC_OPTS="-J-Xmx2g -J-Xms200m"

    # If EMBED_LABEL isn't set, it'd be auto-detected from CHANGELOG.md
    # and `git rev-parse --short HEAD` which would result in
    # "3.7.0- (@non-git)" due to non-git build and incomplete changelog.
    # Actual bazel releases use scripts/release/common.sh which is based
    # on branch/tag information which we don't have with tarball releases.
    # Note that .bazelversion is always correct and is based on bazel-*
    # executable name, version checks should work fine
    export EMBED_LABEL="${version}- (@non-git)"
    ${bash}/bin/bash ./bazel_src/compile.sh
    ./bazel_src/scripts/generate_bash_completion.sh \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.bash \
        --prepend=./bazel_src/scripts/bazel-complete-header.bash \
        --prepend=./bazel_src/scripts/bazel-complete-template.bash
    ${python3}/bin/python3 ./bazel_src/scripts/generate_fish_completion.py \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.fish

    # need to change directory for bazel to find the workspace
    cd ./bazel_src
    # build execlog tooling
    export HOME=$(mktemp -d)
    ./output/bazel build src/tools/execlog:parser_deploy.jar
    cd -

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # official wrapper scripts that searches for $WORKSPACE_ROOT/tools/bazel
    # if it can’t find something in tools, it calls $out/bin/bazel-{version}-{os_arch}
    # The binary _must_ exist with this naming if your project contains a .bazelversion
    # file.
    cp ./bazel_src/scripts/packages/bazel.sh $out/bin/bazel
    wrapProgram $out/bin/bazel $wrapperfile --suffix PATH : ${defaultShellPath}
    mv ./bazel_src/output/bazel $out/bin/bazel-${version}-${system}-${arch}

    mkdir $out/share
    cp ./bazel_src/bazel-bin/src/tools/execlog/parser_deploy.jar $out/share/parser_deploy.jar
    cat <<EOF > $out/bin/bazel-execlog
    #!${runtimeShell} -e
    ${runJdk}/bin/java -jar $out/share/parser_deploy.jar \$@
    EOF
    chmod +x $out/bin/bazel-execlog

    # shell completion files
    installShellCompletion --bash \
      --name bazel.bash \
      ./bazel_src/output/bazel-complete.bash
    installShellCompletion --zsh \
      --name _bazel \
      ./bazel_src/scripts/zsh_completion/_bazel
    installShellCompletion --fish \
      --name bazel.fish \
      ./bazel_src/output/bazel-complete.fish
  '';

  # Install check fails on `aarch64-darwin`
  # https://github.com/NixOS/nixpkgs/issues/145587
  doInstallCheck = stdenv.hostPlatform.system != "aarch64-darwin";
  installCheckPhase = ''
    export TEST_TMPDIR=$(pwd)

    hello_test () {
      $out/bin/bazel test \
        --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
    }

    cd ./bazel_src

    # test whether $WORKSPACE_ROOT/tools/bazel works

    mkdir -p tools
    cat > tools/bazel <<"EOF"
    #!${runtimeShell} -e
    exit 1
    EOF
    chmod +x tools/bazel

    # first call should fail if tools/bazel is used
    ! hello_test

    cat > tools/bazel <<"EOF"
    #!${runtimeShell} -e
    exec "$BAZEL_REAL" "$@"
    EOF

    # second call succeeds because it defers to $out/bin/bazel-{version}-{os_arch}
    hello_test

    runHook postInstall
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  # This is needed because the templates get tar’d up into a .jar.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${defaultShellPath}" >> $out/nix-support/depends
    # The string literal specifying the path to the bazel-rc file is sometimes
    # stored non-contiguously in the binary due to gcc optimisations, which leads
    # Nix to miss the hash when scanning for dependencies
    echo "${bazelRC}" >> $out/nix-support/depends
  '' + lib.optionalString stdenv.isDarwin ''
    echo "${cctools}" >> $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
