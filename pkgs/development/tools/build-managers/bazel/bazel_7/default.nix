{ stdenv
  # nix tooling and utilities
, callPackage
, lib
, fetchurl
, fetchpatch
, fetchFromGitHub
, runCommand
, runCommandCC
, makeWrapper
, recurseIntoAttrs
, newScope
, writeTextFile
, autoPatchelfHook
, substituteAll
  # this package (through the fixpoint glass)
, bazel_self
  # native build inputs
, runtimeShell
, lr
, xe
, zip
, unzip
, bash
, writeCBin
, coreutils
, which
, gawk
, gnused
, gnutar
, gnugrep
, gzip
, findutils
, diffutils
, gnupatch
, file
, installShellFiles
  # updater
, python3
, writeScript
  # Apple dependencies
, cctools
, libcxx
, sigtool
, CoreFoundation
, CoreServices
, Foundation
, IOKit
  # Allow to independently override the jdks used to build and run respectively
, buildJdk
, runJdk
  # Downstream packages for tests
, bazel-watcher
  # Always assume all markers valid (this is needed because we remove markers; they are non-deterministic).
  # Also, don't clean up environment variables (so that NIX_ environment variables are passed to compilers).
, enableNixHacks ? false
}:

let
  version = "7.0.0-pre.20230917.3";
  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    hash = "sha256-sxITaivcJRrQrL+zZtdZohesNgmDtQysIG3BS8SFZd4=";
  };

  # Use builtins.fetchurl to avoid IFD, in particular on hydra
  lockfile = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/bazelbuild/bazel/${version}/MODULE.bazel.lock";
    sha256 = "0z6mlz8cn03qa40mqbw6j6kd6qyn4vgb3bb1kyidazgldxjhrz6y";
  };

  # Two-in-one format
  distDir = repoCache;
  repoCache = callPackage ./bazel-repository-cache.nix {
    inherit lockfile;
    # TODO: efficiently filter so that all tests find their dependencies
    # without downloading 10 jdk versions
    # requiredDeps = ./required-hashes.json;
  };

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
      python3
      unzip
      which
      zip
    ];

  defaultShellPath = lib.makeBinPath defaultShellUtils;

  platforms = lib.platforms.linux ++ lib.platforms.darwin;

  inherit (stdenv.hostPlatform) isDarwin isAarch64;

  system = if isDarwin then "darwin" else "linux";

  # on aarch64 Darwin, `uname -m` returns "arm64"
  arch = with stdenv.hostPlatform; if isDarwin && isAarch64 then "arm64" else parsed.cpu.name;

  bazelRC = writeTextFile {
    name = "bazel-rc";
    text = ''
      startup --server_javabase=${buildJdk}

      build --extra_toolchains=@local_jdk//:all
      build --tool_java_runtime_version=local_jdk
      build --java_runtime_version=local_jdk
      build --repo_env=JAVA_HOME=${buildJdk}${if isDarwin then "/zulu-11.jdk/Contents/Home" else "/lib/openjdk"}

      # load default location for the system wide configuration
      try-import /etc/bazel.bazelrc
    '';
  };

  bazelNixFlagsScript = writeScript "bazel-nix-flags" ''
    cat << EOF
    common --announce_rc
    build --toolchain_resolution_debug=".*"
    build --local_ram_resources=HOST_RAM*.5
    build --local_cpu_resources=HOST_CPUS*.75
    build --copt=$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ / --copt=/g')
    build --host_copt=$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ / --host_copt=/g')
    build --linkopt=$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ / --linkopt=/g')
    build --host_linkopt=$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ / --host_linkopt=/g')
    build --linkopt=-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ / --linkopt=-Wl,/g')
    build --host_linkopt=-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ / --host_linkopt=-Wl,/g')
    build --extra_toolchains=@bazel_tools//tools/jdk:nonprebuilt_toolchain_definition
    build --verbose_failures
    build --curses=no
    build --features=-layering_check
    build --experimental_strict_java_deps=off
    build --strict_proto_deps=off
    build --extra_toolchains=@bazel_tools//tools/jdk:nonprebuilt_toolchain_java11_definition
    build --extra_toolchains=@local_jdk//:all
    build --tool_java_runtime_version=local_jdk_11
    build --java_runtime_version=local_jdk_11
    build --repo_env=JAVA_HOME=${buildJdk}${if isDarwin then "/zulu-11.jdk/Contents/Home" else "/lib/openjdk"}
    EOF
  '';
in
stdenv.mkDerivation rec {
  pname = "bazel";
  inherit version;

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    inherit platforms;
  };

  inherit src;
  inherit sourceRoot;
  patches = [
    # TODO: Make GSON work,
    # In particular, our bazel build cannot emit MODULE.bazel.lock
    # it only produces an empty json object `{ }`.
    ./serialize_nulls.patch

    # Bazel integrates with apple IOKit to inhibit and track system sleep.
    # Inside the darwin sandbox, these API calls are blocked, and bazel
    # crashes. It seems possible to allow these APIs inside the sandbox, but it
    # feels simpler to patch bazel not to use it at all. So our bazel is
    # incapable of preventing system sleep, which is a small price to pay to
    # guarantee that it will always run in any nix context.
    #
    # See also ./bazel_darwin_sandbox.patch in bazel_5. That patch uses
    # NIX_BUILD_TOP env var to conditionnally disable sleep features inside the
    # sandbox. Oddly, bazel_6 does not need that patch :-/.
    #
    # If you want to investigate the sandbox profile path,
    # IORegisterForSystemPower can be allowed with
    #
    #     propagatedSandboxProfile = ''
    #       (allow iokit-open (iokit-user-client-class "RootDomainUserClient"))
    #     '';
    #
    # I do not know yet how to allow IOPMAssertion{CreateWithName,Release}
    ./darwin_sleep.patch

    # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
    # This is breaking the build of any C target. This patch removes the last
    # argument if it's found to be an empty string.
    ../trim-last-argument-to-gcc-if-empty.patch

    # XXX: This seems merged / not a real problem. See PR.
    # TODO: Remove when protobuf tests confirm it is not needed.
    # `java_proto_library` ignores `strict_proto_deps`
    # https://github.com/bazelbuild/bazel/pull/16146
    # ./strict_proto_deps.patch

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
  ]
  # See enableNixHacks argument above.
  ++ lib.optional enableNixHacks ./nix-hacks.patch;


  # Bazel starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  postPatch =
    let
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
        export NIX_LDFLAGS+=" -F${CoreFoundation}/Library/Frameworks -F${CoreServices}/Library/Frameworks -F${Foundation}/Library/Frameworks -F${IOKit}/Library/Frameworks"

        # libcxx includes aren't added by libcxx hook
        # https://github.com/NixOS/nixpkgs/pull/41589
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${lib.getDev libcxx}/include/c++/v1"

        # don't use system installed Xcode to run clang, use Nix clang instead
        sed -i -E \
          -e "s;/usr/bin/xcrun (--sdk macosx )?clang;${stdenv.cc}/bin/clang $NIX_CFLAGS_COMPILE $(bazelLinkFlags) -framework CoreFoundation;g" \
          -e "s;/usr/bin/codesign;CODESIGN_ALLOCATE=${cctools}/bin/${cctools.targetPrefix}codesign_allocate ${sigtool}/bin/codesign;" \
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
        function sedVerbose() {
          local path=$1; shift;
          sed -i".bak-nix" "$path" "$@"
          diff -U0 "$path.bak-nix" "$path" | sed "s/^/  /" || true
          rm -f "$path.bak-nix"
        }

        # unzip builtins_bzl.zip so the contents get patched
        builtins_bzl=src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl
        unzip ''${builtins_bzl}.zip -d ''${builtins_bzl}_zip >/dev/null
        rm ''${builtins_bzl}.zip
        builtins_bzl=''${builtins_bzl}_zip/builtins_bzl

        # md5sum is part of coreutils
        sed -i 's|/sbin/md5|md5sum|g' src/BUILD third_party/ijar/test/testenv.sh

        echo
        echo "Substituting */bin/* hardcoded paths in src/main/java/com/google/devtools"
        # Prefilter the files with grep for speed
        grep -rlZ /bin/ \
          src/main/java/com/google/devtools \
          src/main/starlark/builtins_bzl/common/python \
          tools/python \
          tools/cpp \
          tools/build_rules \
          tools/osx/BUILD \
        | while IFS="" read -r -d "" path; do
          # If you add more replacements here, you must change the grep above!
          # Only files containing /bin are taken into account.
          sedVerbose "$path" \
            -e 's!/usr/local/bin/bash!${bash}/bin/bash!g' \
            -e 's!/usr/bin/bash!${bash}/bin/bash!g' \
            -e 's!/bin/bash!${bash}/bin/bash!g' \
            -e 's!/usr/bin/env bash!${bash}/bin/bash!g' \
            -e 's!/usr/bin/env python2!${python3}/bin/python!g' \
            -e 's!/usr/bin/env python!${python3}/bin/python!g' \
            -e 's!/usr/bin/env!${coreutils}/bin/env!g' \
            -e 's!/bin/true!${coreutils}/bin/true!g'
        done

        # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
        sedVerbose scripts/bootstrap/compile.sh \
          -e 's!/bin/bash!${bash}/bin/bash!g' \
          -e 's!shasum -a 256!sha256sum!g'

        # Add compile options to command line.
        # XXX: It would suit a bazelrc file better, but I found no way to pass it.
        #      It seems it is always ignored.
        #      Passing EXTRA_BAZEL_ARGS is tricky due to quoting.

        sedVerbose compile.sh \
          -e "/bazel_build /a\  --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\" \\\\" \
          -e "/bazel_build /a\  --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\" \\\\" \
          -e "/bazel_build /a\  --linkopt=\"$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --linkopt=\"/g')\" \\\\" \
          -e "/bazel_build /a\  --host_linkopt=\"$(echo $(< ${stdenv.cc}/nix-support/libcxx-ldflags) | sed -e 's/ /" --host_linkopt=\"/g')\" \\\\" \
          -e "/bazel_build /a\  --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\" \\\\" \
          -e "/bazel_build /a\  --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\" \\\\" \
          -e "/bazel_build /a\  --verbose_failures \\\\" \
          -e "/bazel_build /a\  --curses=no \\\\" \
          -e "/bazel_build /a\  --features=-layering_check \\\\" \
          -e "/bazel_build /a\  --experimental_strict_java_deps=off \\\\" \
          -e "/bazel_build /a\  --strict_proto_deps=off \\\\" \
          -e "/bazel_build /a\  --tool_java_runtime_version=local_jdk \\\\" \
          -e "/bazel_build /a\  --java_runtime_version=local_jdk \\\\" \
          -e "/bazel_build /a\  --repo_env=JAVA_HOME=${buildJdk}/${if isDarwin then "/zulu-11.jdk/Contents/Home" else "/lib/openjdk"} \\\\" \
          -e "/bazel_build /a\  --extra_toolchains=@local_jdk//:all \\\\" \
          -e "/bazel_build /a\  --toolchain_resolution_debug=@bazel_tools//tools/jdk:runtime_toolchain_type \\\\" \
          -e "/bazel_build /a\  --sandbox_debug --verbose_failures \\\\" \

        # Also build parser_deploy.jar with bootstrap bazel
        # TODO: Turn into a proper patch
        sedVerbose compile.sh \
          -e 's!bazel_build !bazel_build src/tools/execlog:parser_deploy.jar !' \
          -e 's!clear_log!cp $(get_bazel_bin_path)/src/tools/execlog/parser_deploy.jar output\nclear_log!'


        # This is necessary to avoid:
        # "error: no visible @interface for 'NSDictionary' declares the selector
        # 'initWithContentsOfURL:error:'"
        # This can be removed when the apple_sdk is upgraded beyond 10.13+
        sedVerbose tools/osx/xcode_locator.m \
          -e '/initWithContentsOfURL:versionPlistUrl/ {
            N
            s/error:nil\];/\];/
          }'

        # append the PATH with defaultShellPath in tools/bash/runfiles/runfiles.bash
        echo "PATH=\$PATH:${defaultShellPath}" >> runfiles.bash.tmp
        cat tools/bash/runfiles/runfiles.bash >> runfiles.bash.tmp
        mv runfiles.bash.tmp tools/bash/runfiles/runfiles.bash

        # reconstruct the now patched builtins_bzl.zip
        pushd src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip &>/dev/null
          zip ../builtins_bzl.zip $(find builtins_bzl -type f) >/dev/null
          rm -rf builtins_bzl
        popd &>/dev/null
        rmdir src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip

        patchShebangs . >/dev/null
      '';
    in
    lib.optionalString isDarwin darwinPatches + genericPatches;

  buildInputs = [ buildJdk ] ++ defaultShellUtils;

  # when a command can’t be found in a bazel build, you might also
  # need to add it to `defaultShellPath`.
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    python3
    unzip
    which
    zip
    python3.pkgs.absl-py # Needed to build fish completion
  ] ++ lib.optionals (stdenv.isDarwin) [
    cctools
    libcxx
    CoreFoundation
    CoreServices
    Foundation
  ];

  # Bazel makes extensive use of symlinks in the WORKSPACE.
  # This causes problems with infinite symlinks if the build output is in the same location as the
  # Bazel WORKSPACE. This is why before executing the build, the source code is moved into a
  # subdirectory.
  # Failing to do this causes "infinite symlink expansion detected"
  preBuildPhases = [ "preBuildPhase" ];
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
    echo "Stage 1 - Running bazel bootstrap script"
    ${bash}/bin/bash ./bazel_src/compile.sh

    # XXX: get rid of this, or move it to another stage.
    # It is plain annoying when builds fail.
    echo "Stage 2 - Generate bazel completions"
    ${bash}/bin/bash ./bazel_src/scripts/generate_bash_completion.sh \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.bash \
        --prepend=./bazel_src/scripts/bazel-complete-header.bash \
        --prepend=./bazel_src/scripts/bazel-complete-template.bash
    ${python3}/bin/python3 ./bazel_src/scripts/generate_fish_completion.py \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.fish

    #echo "Stage 3 - Generate parser_deploy.jar"
    # XXX: for now, build in the patched compile.sh script to get all the args right.
    ## need to change directory for bazel to find the workspace
    #cd ./bazel_src
    ## build execlog tooling
    #export HOME=$(mktemp -d)
    #./output/bazel build src/tools/execlog:parser_deploy.jar
    #cd -

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # official wrapper scripts that searches for $WORKSPACE_ROOT/tools/bazel if
    # it can’t find something in tools, it calls
    # $out/bin/bazel-{version}-{os_arch} The binary _must_ exist with this
    # naming if your project contains a .bazelversion file.
    cp ./bazel_src/scripts/packages/bazel.sh $out/bin/bazel
    wrapProgram $out/bin/bazel $wrapperfile --suffix PATH : ${defaultShellPath}
    mv ./bazel_src/output/bazel $out/bin/bazel-${version}-${system}-${arch}

    mkdir $out/share
    cp ./bazel_src/output/parser_deploy.jar $out/share/parser_deploy.jar
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
  doInstallCheck = false; #stdenv.hostPlatform.system != "aarch64-darwin";
  installCheckPhase = ''
    export TEST_TMPDIR=$(pwd)

    hello_test () {
      $out/bin/bazel test \
        --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
    }

    cd ./bazel_src

    # If .bazelversion file is present in dist files and doesn't match `bazel` version
    # running `bazel` command within bazel_src will fail.
    # Let's remove .bazelversion within the test, if present it is meant to indicate bazel version
    # to compile bazel with, not version of bazel to be built and tested.
    rm -f .bazelversion

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

  passthru = {
    # Additional tests that check bazel’s functionality. Execute
    #
    #     nix-build . -A bazel_7.tests
    #
    # in the nixpkgs checkout root to exercise them locally.
    tests = callPackage ./tests.nix {
      inherit Foundation bazel_self distDir repoCache runJdk;
    };

    updater = throw "TODO";

    inherit distDir repoCache;
  };
}
