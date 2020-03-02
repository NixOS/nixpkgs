{ stdenv, callPackage, lib, fetchurl, fetchFromGitHub
, runCommand, runCommandCC, makeWrapper, recurseIntoAttrs
# this package (through the fixpoint glass)
, bazel_1
, lr, xe, zip, unzip, bash, writeCBin, coreutils
, which, gawk, gnused, gnutar, gnugrep, gzip, findutils
# updater
, python27, python3, writeScript
# Apple dependencies
, cctools, libcxx, CoreFoundation, CoreServices, Foundation
# Allow to independently override the jdks used to build and run respectively
, buildJdk, runJdk
, buildJdkName
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
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "1qfk14mgx1m454b4w4ldggljzqkqwpdwrlynq7rc8aq11yfs8p95";
  };

  # Update with `eval $(nix-build -A bazel.updater)`,
  # then add new dependencies from the dict in ./src-deps.json as required.
  srcDeps = lib.attrsets.attrValues srcDepsSet;
  srcDepsSet =
    let
      srcs = (builtins.fromJSON (builtins.readFile ./src-deps.json));
      toFetchurl = d: lib.attrsets.nameValuePair d.name (fetchurl {
        urls = d.urls;
        sha256 = d.sha256;
        });
        in builtins.listToAttrs (map toFetchurl [
      srcs.desugar_jdk_libs
      srcs.io_bazel_skydoc
      srcs.bazel_skylib
      srcs.io_bazel_rules_sass
      srcs.platforms
      (if stdenv.hostPlatform.isDarwin
       then srcs."java_tools_javac11_darwin-v6.1.zip"
       else srcs."java_tools_javac11_linux-v6.1.zip")
      srcs."coverage_output_generator-v2.0.zip"
      srcs.build_bazel_rules_nodejs
      srcs."android_tools_pkg-0.12.tar.gz"
      srcs."0.28.3.tar.gz"
      srcs.rules_pkg
      srcs.rules_cc
      srcs.rules_java
      srcs.rules_proto
      ]);

  distDir = runCommand "bazel-deps" {} ''
    mkdir -p $out
    for i in ${builtins.toString srcDeps}; do cp $i $out/$(stripHash $i); done
  '';

  defaultShellPath = lib.makeBinPath
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
    #
    [ bash coreutils findutils gawk gnugrep gnutar gnused gzip which unzip file zip ];

  # Java toolchain used for the build and tests
  javaToolchain = "@bazel_tools//tools/jdk:toolchain_host${buildJdkName}";

  platforms = lib.platforms.linux ++ lib.platforms.darwin;

  # This repository is fetched by bazel at runtime
  # however it contains prebuilt java binaries, with wrong interpreter
  # and libraries path.
  # We prefetch it, patch it, and override it in a global bazelrc.
  system = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";

  remote_java_tools = stdenv.mkDerivation {
    name = "remote_java_tools_${system}";

    src = srcDepsSet."java_tools_javac11_${system}-v6.1.zip";

    nativeBuildInputs = [ autoPatchelfHook unzip ];
    buildInputs = [ gcc-unwrapped ];

    sourceRoot = ".";

    buildPhase = ''
      mkdir $out;
    '';

    installPhase = ''
      cp -Ra * $out/
      touch $out/WORKSPACE
    '';
  };

  bazelRC = writeTextFile {
    name = "bazel-rc";
    text = ''
      build --override_repository=${remote_java_tools.name}=${remote_java_tools}
      build --distdir=${distDir}
      startup --server_javabase=${runJdk}

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
    license = licenses.asl20;
    maintainers = [ maintainers.mboes ];
    inherit platforms;
  };

  inherit src;
  sourceRoot = ".";

  patches = [
    # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
    # This is breaking the build of any C target. This patch removes the last
    # argument if it's found to be an empty string.
    ../trim-last-argument-to-gcc-if-empty.patch
    ./glibc.patch

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

    # bazel reads its system bazelrc in /etc
    # override this path to a builtin one
    (substituteAll {
      src = ../bazel_rc.patch;
      bazelSystemBazelRCPath = bazelRC;
    })
  ] ++ lib.optional enableNixHacks ../nix-hacks.patch;


  # Additional tests that check bazel’s functionality. Execute
  #
  #     nix-build . -A bazel.tests
  #
  # in the nixpkgs checkout root to exercise them locally.
  passthru.tests =
    let
      runLocal = name: attrs: script:
      let
        attrs' = removeAttrs attrs [ "buildInputs" ];
        buildInputs = [ python3 ] ++ (attrs.buildInputs or []);
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

      bazelWithNixHacks = bazel_1.override { enableNixHacks = true; };

      bazel-examples = fetchFromGitHub {
        owner = "bazelbuild";
        repo = "examples";
        rev = "5d8c8961a2516ebf875787df35e98cadd08d43dc";
        sha256 = "03c1bwlq5bs3hg96v4g4pg2vqwhqq6w538h66rcpw02f83yy7fs8";
      };

    in (if !stdenv.hostPlatform.isDarwin then {
      # `extracted` doesn’t work on darwin
      shebang = callPackage ./shebang-test.nix { inherit runLocal extracted bazelTest distDir; };
    } else {}) // {
      bashTools = callPackage ./bash-tools-test.nix { inherit runLocal bazelTest distDir; };
      cpp = callPackage ./cpp-test.nix { inherit runLocal bazelTest bazel-examples distDir; };
      java = callPackage ./java-test.nix { inherit runLocal bazelTest bazel-examples distDir; };
      protobuf = callPackage ./protobuf-test.nix { inherit runLocal bazelTest distDir; };
      pythonBinPath = callPackage ./python-bin-path-test.nix { inherit runLocal bazelTest distDir; };

      bashToolsWithNixHacks = callPackage ./bash-tools-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };

      cppWithNixHacks = callPackage ./cpp-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazelWithNixHacks; };
      javaWithNixHacks = callPackage ./java-test.nix { inherit runLocal bazelTest bazel-examples distDir; bazel = bazelWithNixHacks; };
      protobufWithNixHacks = callPackage ./protobuf-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };
      pythonBinPathWithNixHacks = callPackage ./python-bin-path-test.nix { inherit runLocal bazelTest distDir; bazel = bazelWithNixHacks; };

      # downstream packages using buildBazelPackage
      # fixed-output hashes of the fetch phase need to be spot-checked manually
      downstream = recurseIntoAttrs ({
        inherit bazel-watcher;
      }
          # dm-sonnet is only packaged for linux
      // (lib.optionalAttrs stdenv.isLinux {
          # TODO(timokau) dm-sonnet is broken currently
          # dm-sonnet-linux = python3.pkgs.dm-sonnet;
      }));
    };

  # update the list of workspace dependencies
  passthru.updater = writeScript "update-bazel-deps.sh" ''
    #!${runtimeShell}
    cat ${runCommand "bazel-deps.json" {} ''
        ${unzip}/bin/unzip ${src} WORKSPACE
        ${python3}/bin/python3 ${../update-srcDeps.py} ./WORKSPACE > $out
    ''} > ${builtins.toString ./src-deps.json}
  '';

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Bazel starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  # Bazel expects several utils to be available in Bash even without PATH. Hence this hack.
  customBash = writeCBin "bash" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>

    extern char **environ;

    int main(int argc, char *argv[]) {
      char *path = getenv("PATH");
      char *pathToAppend = "${defaultShellPath}";
      char *newPath;
      if (path != NULL) {
        int length = strlen(path) + 1 + strlen(pathToAppend) + 1;
        newPath = malloc(length * sizeof(char));
        snprintf(newPath, length, "%s:%s", path, pathToAppend);
      } else {
        newPath = pathToAppend;
      }
      setenv("PATH", newPath, 1);
      execve("${bash}/bin/bash", argv, environ);
      return 0;
    }
  '';

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
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${libcxx}/include/c++/v1"

      # don't use system installed Xcode to run clang, use Nix clang instead
      sed -i -E "s;/usr/bin/xcrun (--sdk macosx )?clang;${stdenv.cc}/bin/clang $NIX_CFLAGS_COMPILE $(bazelLinkFlags) -framework CoreFoundation;g" \
        scripts/bootstrap/compile.sh \
        src/tools/xcode/realpath/BUILD \
        src/tools/xcode/stdredirect/BUILD \
        tools/osx/BUILD

      # nixpkgs's libSystem cannot use pthread headers directly, must import GCD headers instead
      sed -i -e "/#include <pthread\/spawn.h>/i #include <dispatch/dispatch.h>" src/main/cpp/blaze_util_darwin.cc

      # clang installed from Xcode has a compatibility wrapper that forwards
      # invocations of gcc to clang, but vanilla clang doesn't
      sed -i -e 's;_find_generic(repository_ctx, "gcc", "CC", overriden_tools);_find_generic(repository_ctx, "clang", "CC", overriden_tools);g' tools/cpp/unix_cc_configure.bzl

      sed -i -e 's;/usr/bin/libtool;${cctools}/bin/libtool;g' tools/cpp/unix_cc_configure.bzl
      wrappers=( tools/cpp/osx_cc_wrapper.sh tools/cpp/osx_cc_wrapper.sh.tpl )
      for wrapper in "''${wrappers[@]}"; do
        sed -i -e "s,/usr/bin/install_name_tool,${cctools}/bin/install_name_tool,g" $wrapper
      done
    '';

    genericPatches = ''
      # Substitute j2objc and objc wrapper's python shebang to plain python path.
      # These scripts explicitly depend on Python 2.7, hence we use python27.
      # See also `postFixup` where python27 is added to $out/nix-support
      substituteInPlace tools/j2objc/j2objc_header_map.py --replace "$!/usr/bin/python2.7" "#!${python27}/bin/python"
      substituteInPlace tools/j2objc/j2objc_wrapper.py --replace "$!/usr/bin/python2.7" "#!${python27}/bin/python"
      substituteInPlace tools/objc/j2objc_dead_code_pruner.py --replace "$!/usr/bin/python2.7" "#!${python27}/bin/python"

      # md5sum is part of coreutils
      sed -i 's|/sbin/md5|md5sum|' \
        src/BUILD

      # substituteInPlace is rather slow, so prefilter the files with grep
      grep -rlZ /bin src/main/java/com/google/devtools | while IFS="" read -r -d "" path; do
        # If you add more replacements here, you must change the grep above!
        # Only files containing /bin are taken into account.
        # We default to python3 where possible. See also `postFixup` where
        # python3 is added to $out/nix-support
        substituteInPlace "$path" \
          --replace /bin/bash ${customBash}/bin/bash \
          --replace "/usr/bin/env bash" ${customBash}/bin/bash \
          --replace "/usr/bin/env python" ${python3}/bin/python \
          --replace /usr/bin/env ${coreutils}/bin/env \
          --replace /bin/true ${coreutils}/bin/true
      done

      # bazel test runner include references to /bin/bash
      substituteInPlace tools/build_rules/test_rules.bzl \
        --replace /bin/bash ${customBash}/bin/bash

      for i in $(find tools/cpp/ -type f)
      do
        substituteInPlace $i \
          --replace /bin/bash ${customBash}/bin/bash
      done

      # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
      substituteInPlace scripts/bootstrap/compile.sh \
          --replace /bin/bash ${customBash}/bin/bash

      # add nix environment vars to .bazelrc
      cat >> .bazelrc <<EOF
      build --distdir=${distDir}
      fetch --distdir=${distDir}
      build --copt="$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt="/g')"
      build --host_copt="$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt="/g')"
      build --linkopt="-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt="-Wl,/g')"
      build --host_linkopt="-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt="-Wl,/g')"
      build --host_javabase='@local_jdk//:jdk'
      build --host_java_toolchain='${javaToolchain}'
      EOF

      # add the same environment vars to compile.sh
      sed -e "/\$command \\\\$/a --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\" \\\\" \
          -e "/\$command \\\\$/a --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\" \\\\" \
          -e "/\$command \\\\$/a --host_javabase='@local_jdk//:jdk' \\\\" \
          -e "/\$command \\\\$/a --host_java_toolchain='${javaToolchain}' \\\\" \
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

  buildInputs = [
    buildJdk
    python3
  ];

  # when a command can’t be found in a bazel build, you might also
  # need to add it to `defaultShellPath`.
  nativeBuildInputs = [
    zip
    python3
    unzip
    makeWrapper
    which
    customBash
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
    # Increasing memory during compilation might be necessary.
    # export BAZEL_JAVAC_OPTS="-J-Xmx2g -J-Xms200m"
    ./bazel_src/compile.sh
    ./bazel_src/scripts/generate_bash_completion.sh \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.bash \
        --prepend=./bazel_src/scripts/bazel-complete-header.bash \
        --prepend=./bazel_src/scripts/bazel-complete-template.bash
  '';

  installPhase = ''
    mkdir -p $out/bin

    # official wrapper scripts that searches for $WORKSPACE_ROOT/tools/bazel
    # if it can’t find something in tools, it calls $out/bin/bazel-real
    cp ./bazel_src/scripts/packages/bazel.sh $out/bin/bazel
    mv ./bazel_src/output/bazel $out/bin/bazel-real

    # shell completion files
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv ./bazel_src/output/bazel-complete.bash $out/share/bash-completion/completions/bazel
    cp ./bazel_src/scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export TEST_TMPDIR=$(pwd)

    hello_test () {
      $out/bin/bazel test --distdir=${distDir} \
        --test_output=errors \
        --java_toolchain='${javaToolchain}' \
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

    # second call succeeds because it defers to $out/bin/bazel-real
    hello_test
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${customBash} ${defaultShellPath}" >> $out/nix-support/depends
    # The templates get tar’d up into a .jar,
    # so nix can’t detect python is needed in the runtime closure
    # Some of the scripts explicitly depend on Python 2.7. Otherwise, we
    # default to using python3. Therefore, both python27 and python3 are
    # runtime dependencies.
    echo "${python27}" >> $out/nix-support/depends
    echo "${python3}" >> $out/nix-support/depends
  '' + lib.optionalString stdenv.isDarwin ''
    echo "${cctools}" >> $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
