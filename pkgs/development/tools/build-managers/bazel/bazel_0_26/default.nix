{ stdenv, callPackage, lib, fetchurl, fetchpatch, runCommand, makeWrapper
, zip, unzip, bash, writeCBin, coreutils
, which, python, perl, gawk, gnused, gnutar, gnugrep, gzip, findutils
# Apple dependencies
, cctools, clang, libcxx, CoreFoundation, CoreServices, Foundation
# Allow to independently override the jdks used to build and run respectively
, buildJdk, runJdk
, buildJdkName
, runtimeShell
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
}:

let
  srcDeps = [
    # From: $REPO_ROOT/WORKSPACE
    (fetchurl {
      url = "https://github.com/google/desugar_jdk_libs/archive/915f566d1dc23bc5a8975320cd2ff71be108eb9c.zip";
      sha256 = "0b926df7yxyyyiwm9cmdijy6kplf0sghm23sf163zh8wrk87wfi7";
    })
    (fetchurl {
        url = "https://mirror.bazel.build/github.com/bazelbuild/skydoc/archive/2d9566b21fbe405acf5f7bf77eda30df72a4744c.tar.gz";
        sha256 = "4a1318fed4831697b83ce879b3ab70ae09592b167e5bda8edaff45132d1c3b3f";
    })
    (fetchurl {
        url = "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/archive/f83cb8dd6f5658bc574ccd873e25197055265d1c.tar.gz";
        sha256 = "ba5d15ca230efca96320085d8e4d58da826d1f81b444ef8afccd8b23e0799b52";
    })
    (fetchurl {
      url = "https://mirror.bazel.build/github.com/bazelbuild/rules_sass/archive/8ccf4f1c351928b55d5dddf3672e3667f6978d60.tar.gz";
      sha256 = "d868ce50d592ef4aad7dec4dd32ae68d2151261913450fac8390b3fd474bb898";
    })
     (fetchurl {
         url = "https://mirror.bazel.build/bazel_java_tools/releases/javac10/v3.1/java_tools_javac10_linux-v3.1.zip";
         sha256 = "a0cd51f9db1bf05a722ff7f5c60a07fa1c7d27428fff0815c342d32aa6c53576";
     })
    (fetchurl {
        url = "https://mirror.bazel.build/bazel_java_tools/releases/javac10/v3.1/java_tools_javac10_darwin-v3.1.zip";
        sha256 = "c646aad8808b8ec5844d6a80a1287fc8e13203375fe40d6af4819eff48b9bbaf";
    })
    (fetchurl {
        url = "https://mirror.bazel.build/bazel_coverage_output_generator/releases/coverage_output_generator-v1.0.zip";
        sha256 = "cc470e529fafb6165b5be3929ff2d99b38429b386ac100878687416603a67889";
    })
    (fetchurl {
        url = "https://github.com/bazelbuild/rules_nodejs/archive/0.16.2.zip";
        sha256 = "9b72bb0aea72d7cbcfc82a01b1e25bf3d85f791e790ddec16c65e2d906382ee0";
    })
    (fetchurl {
        url = "https://mirror.bazel.build/bazel_android_tools/android_tools_pkg-0.2.tar.gz";
        sha256 = "04f85f2dd049e87805511e3babc5cea3f5e72332b1627e34f3a5461cc38e815f";
    })
  ];

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
    [ bash coreutils findutils gawk gnugrep gnutar gnused gzip which unzip ];

  # Java toolchain used for the build and tests
  javaToolchain = "@bazel_tools//tools/jdk:toolchain_host${buildJdkName}";

in
stdenv.mkDerivation rec {

  version = "0.26.0";

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };

  # Additional tests that check bazel’s functionality. Execute
  #
  #     nix-build . -A bazel.tests
  #
  # in the nixpkgs checkout root to exercise them locally.
  passthru.tests = {
    pythonBinPath = callPackage ./python-bin-path-test.nix {};
    bashTools = callPackage ./bash-tools-test.nix {};
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/${name}-dist.zip";
    sha256 = "d26dadf62959255d58e523da3448a6222af768fe1224e321b120c1d5bbe4b4f2";
  };

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Bazel starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  sourceRoot = ".";

  patches = [
    ./glibc.patch
    ./python-stub-path-fix.patch
  ] ++ lib.optional enableNixHacks ../nix-hacks.patch;

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
      # Disable Bazel's Xcode toolchain detection which would configure compilers
      # and linkers from Xcode instead of from PATH
      export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

      # Explicitly configure gcov since we don't have it on Darwin, so autodetection fails
      export GCOV=${coreutils}/bin/false

      # Framework search paths aren't added by bintools hook
      # https://github.com/NixOS/nixpkgs/pull/41914
      export NIX_LDFLAGS="$NIX_LDFLAGS -F${CoreFoundation}/Library/Frameworks -F${CoreServices}/Library/Frameworks -F${Foundation}/Library/Frameworks"

      # libcxx includes aren't added by libcxx hook
      # https://github.com/NixOS/nixpkgs/pull/41589
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${libcxx}/include/c++/v1"

      # don't use system installed Xcode to run clang, use Nix clang instead
      sed -i -e "s;/usr/bin/xcrun clang;${stdenv.cc}/bin/clang $NIX_CFLAGS_COMPILE $NIX_LDFLAGS -framework CoreFoundation;g" \
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
      # Substitute python's stub shebang to plain python path. (see TODO add pr URL)
      # See also `postFixup` where python is added to $out/nix-support
      substituteInPlace src/main/java/com/google/devtools/build/lib/bazel/rules/python/python_stub_template.txt\
          --replace "/usr/bin/env python" "${python}/bin/python" \
          --replace "NIX_STORE_PYTHON_PATH" "${python}/bin/python" \

      # md5sum is part of coreutils
      sed -i 's|/sbin/md5|md5sum|' \
        src/BUILD

      # substituteInPlace is rather slow, so prefilter the files with grep
      grep -rlZ /bin src/main/java/com/google/devtools | while IFS="" read -r -d "" path; do
        # If you add more replacements here, you must change the grep above!
        # Only files containing /bin are taken into account.
        substituteInPlace "$path" \
          --replace /bin/bash ${customBash}/bin/bash \
          --replace /usr/bin/env ${coreutils}/bin/env \
          --replace /bin/true ${coreutils}/bin/true
      done

      # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
      substituteInPlace scripts/bootstrap/compile.sh \
          --replace /bin/bash ${customBash}/bin/bash

      # add nix environment vars to .bazelrc
      cat >> .bazelrc <<EOF
      build --experimental_distdir=${distDir}
      fetch --experimental_distdir=${distDir}
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

      # --experimental_strict_action_env (which will soon become the
      # default, see bazelbuild/bazel#2574) hardcodes the default
      # action environment to a value that on NixOS at least is bogus.
      # So we hardcode it to something useful.
      substituteInPlace \
        src/main/java/com/google/devtools/build/lib/bazel/rules/BazelRuleClassProvider.java \
        --replace /bin:/usr/bin ${defaultShellPath}

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
  ];

  # when a command can’t be found in a bazel build, you might also
  # need to add it to `defaultShellPath`.
  nativeBuildInputs = [
    zip
    python
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

    wrapProgram "$out/bin/bazel" --add-flags --server_javabase="${runJdk}"

    # shell completion files
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv ./bazel_src/output/bazel-complete.bash $out/share/bash-completion/completions/bazel
    cp ./bazel_src/scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  # Temporarily disabling for now. A new approach is needed for this derivation as Bazel
  # accesses the internet during the tests which fails in a sandbox.
  doInstallCheck = false;
  installCheckPhase = ''
    export TEST_TMPDIR=$(pwd)

    hello_test () {
      $out/bin/bazel test \
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
    echo "${python}" >> $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
