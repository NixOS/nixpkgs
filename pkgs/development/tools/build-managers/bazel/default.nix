{ stdenv, lib, fetchurl, fetchpatch, runCommand, makeWrapper
, jdk, zip, unzip, bash, writeCBin, coreutils
, which, python, perl, gnused, gnugrep, findutils
# Apple dependencies
, cctools, clang, libcxx, CoreFoundation, CoreServices, Foundation
# Allow to independently override the jdks used to build and run respectively
, buildJdk ? jdk, runJdk ? jdk
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
}:

let
  srcDeps = lib.singleton (
    fetchurl {
      url = "https://github.com/google/desugar_jdk_libs/archive/fd937f4180c1b557805219af4482f1a27eb0ff2b.zip";
      sha256 = "04hs399340xfwcdajbbcpywnb2syp6z5ydwg966if3hqdb2zrf23";
    }
  );

  distDir = runCommand "bazel-deps" {} ''
    mkdir -p $out
    for i in ${builtins.toString srcDeps}; do cp $i $out/$(stripHash $i); done
  '';

  defaultShellPath = lib.makeBinPath [ bash coreutils findutils gnugrep gnused which ];

in
stdenv.mkDerivation rec {

  version = "0.18.0";

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.mboes ];
    platforms = platforms.linux ++ platforms.darwin;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "0mbi4n4wp1x73l8qksg4vyh2sba52xh9hfl2m518gv41g0pnvs6h";
  };

  sourceRoot = ".";

  patches =
    lib.optional enableNixHacks ./nix-hacks.patch;

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

      # 10.10 apple_sdk Foundation doesn't have type arguments on classes
      # Remove this when we update apple_sdk
      sed -i -e 's/<.*\*>//g' tools/osx/xcode_locator.m

      # don't use system installed Xcode to run clang, use Nix clang instead
      sed -i -e "s;/usr/bin/xcrun clang;${clang}/bin/clang $NIX_CFLAGS_COMPILE $NIX_LDFLAGS -framework CoreFoundation;g" \
        scripts/bootstrap/compile.sh \
        src/tools/xcode/realpath/BUILD \
        src/tools/xcode/stdredirect/BUILD \
        tools/osx/BUILD

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
      find src/main/java/com/google/devtools -type f -print0 | while IFS="" read -r -d "" path; do
        substituteInPlace "$path" \
          --replace /bin/bash ${customBash}/bin/bash \
          --replace /usr/bin/env ${coreutils}/bin/env
      done
      # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
      substituteInPlace scripts/bootstrap/compile.sh \
          --replace /bin/sh ${customBash}/bin/bash

      echo "build --experimental_distdir=${distDir}" >> .bazelrc
      echo "fetch --experimental_distdir=${distDir}" >> .bazelrc
      echo "build --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\"" >> .bazelrc
      echo "build --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\"" >> .bazelrc
      echo "build --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\"" >> .bazelrc
      echo "build --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\"" >> .bazelrc
      sed -i -e "378 a --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\" \\\\" scripts/bootstrap/compile.sh
      sed -i -e "378 a --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\" \\\\" scripts/bootstrap/compile.sh
      sed -i -e "378 a --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\" \\\\" scripts/bootstrap/compile.sh
      sed -i -e "378 a --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\" \\\\" scripts/bootstrap/compile.sh

      # --experimental_strict_action_env (which will soon become the
      # default, see bazelbuild/bazel#2574) hardcodes the default
      # action environment to a value that on NixOS at least is bogus.
      # So we hardcode it to something useful.
      substituteInPlace \
        src/main/java/com/google/devtools/build/lib/bazel/rules/BazelRuleClassProvider.java \
        --replace /bin:/usr/bin ${defaultShellPath}

      # append the PATH with defaultShellPath in tools/bash/runfiles/runfiles.bash
      echo "PATH=$PATH:${defaultShellPath}" >> runfiles.bash.tmp
      cat tools/bash/runfiles/runfiles.bash >> runfiles.bash.tmp
      mv runfiles.bash.tmp tools/bash/runfiles/runfiles.bash

      patchShebangs .
    '';
    in lib.optionalString stdenv.hostPlatform.isDarwin darwinPatches
     + genericPatches;

  buildInputs = [
    buildJdk
  ];

  nativeBuildInputs = [
    zip
    python
    unzip
    makeWrapper
    which
    customBash
  ] ++ lib.optionals (stdenv.isDarwin) [ cctools clang libcxx CoreFoundation CoreServices Foundation ];

  # If TMPDIR is in the unpack dir we run afoul of blaze's infinite symlink
  # detector (see com.google.devtools.build.lib.skyframe.FileFunction).
  # Change this to $(mktemp -d) as soon as we figure out why.

  buildPhase = ''
    export TMPDIR=/tmp/.bazel-$UID
    ./compile.sh
    scripts/generate_bash_completion.sh \
        --bazel=./output/bazel \
        --output=output/bazel-complete.bash \
        --prepend=scripts/bazel-complete-template.bash
  '';

  # Build the CPP and Java examples to verify that Bazel works.

  doCheck = true;
  checkPhase = ''
    export TEST_TMPDIR=$(pwd)
    ./output/bazel test --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv output/bazel $out/bin
    wrapProgram "$out/bin/bazel" --set JAVA_HOME "${runJdk}"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/bazel
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${customBash} ${defaultShellPath}" > $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
