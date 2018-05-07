{ stdenv, lib, fetchurl, jdk, zip, unzip, bash, writeScriptBin, coreutils, makeWrapper
, which, perl, python, gnused, gnugrep, findutils, diffutils, gawk
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
}:

stdenv.mkDerivation rec {

  version = "0.13.0";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = platforms.linux;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "82e9035084660b9c683187618a29aa896f8b05b5f16ae4be42a80b5e5b6a7690";
  };

  sourceRoot = ".";

  patches = [ ./full-paths.patch ] ++ lib.optionals (enableNixHacks) [ ./nix-hacks.patch ];

  postPatch = ''
    paths=(
      scripts/packages/bazel.sh
      src/main/java/com/google/devtools/build/lib/analysis/CommandHelper.java
      src/main/java/com/google/devtools/build/lib/bazel/rules/BazelConfiguration.java
      src/main/java/com/google/devtools/build/lib/rules/objc/ObjcRuleClasses.java
      src/main/java/com/google/devtools/build/lib/util/CommandBuilder.java
      src/main/java/com/google/devtools/build/lib/bazel/rules/BazelConfiguration.java
      src/test/java/com/google/devtools/build/lib/bazel/rules/BazelConfigurationTest.java
      src/test/java/com/google/devtools/build/lib/bazel/rules/genrule/GenRuleConfiguredTargetTest.java
      src/test/java/com/google/devtools/build/lib/shell/CommandLargeInputsTest.java
      src/test/java/com/google/devtools/build/lib/shell/CommandTest.java
      src/test/java/com/google/devtools/build/lib/skylark/SkylarkRuleImplementationFunctionsTest.java
      src/test/java/com/google/devtools/build/lib/standalone/StandaloneSpawnStrategyTest.java
      src/test/shell/integration/linux-sandbox_test.sh
      tools/cpp/osx_cc_wrapper.sh
      tools/cpp/osx_cc_wrapper.sh.tpl
      tools/genrule/genrule-setup.sh
      tools/test/collect_coverage.sh
      tools/test/test-setup.sh
    )
    for path in "''${paths[@]}"; do
      substituteInPlace "$path" \
        --replace '<~>bash<~>' ${bash} \
        --replace '<~>coreutils<~>' ${coreutils} \
        --replace '<~>gnused<~>' ${gnused} \
        --replace '<~>gnugrep<~>' ${gnugrep} \
        --replace '<~>perl<~>' ${perl} \
        --replace '<~>zip<~>' ${zip} \
        --replace '<~>unzip<~>' ${unzip} \
        --replace '<~>python<~>' ${python} \
        --replace '<~>findutils<~>' ${findutils} \
        --replace '<~>diffutils<~>' ${diffutils} \
        --replace '<~>gawk<~>' ${gawk}
    done
    echo "build --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\"" >> .bazelrc
    echo "build --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\"" >> .bazelrc
    echo "build --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\"" >> .bazelrc
    echo "build --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\"" >> .bazelrc
    sed -i -e "362 a --copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --copt=\"/g')\" \\\\" scripts/bootstrap/compile.sh
    sed -i -e "362 a --host_copt=\"$(echo $NIX_CFLAGS_COMPILE | sed -e 's/ /" --host_copt=\"/g')\" \\\\" scripts/bootstrap/compile.sh
    sed -i -e "362 a --linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --linkopt=\"-Wl,/g')\" \\\\" scripts/bootstrap/compile.sh
    sed -i -e "362 a --host_linkopt=\"-Wl,$(echo $NIX_LDFLAGS | sed -e 's/ /" --host_linkopt=\"-Wl,/g')\" \\\\" scripts/bootstrap/compile.sh
    patchShebangs .
  '';

  buildInputs = [
    jdk
  ];

  nativeBuildInputs = [
    zip
    perl
    python
    unzip
    makeWrapper
    which
    bash
    coreutils
    gnused
    gnugrep
    diffutils
    gawk
  ];

  # If TMPDIR is in the unpack dir we run afoul of blaze's infinite symlink
  # detector (see com.google.devtools.build.lib.skyframe.FileFunction).
  # Change this to $(mktemp -d) as soon as we figure out why.

  buildPhase = ''
    export TMPDIR=/tmp
    ./compile.sh
    ./output/bazel --output_user_root=/tmp/.bazel build //scripts:bash_completion \
      --spawn_strategy=standalone \
      --genrule_strategy=standalone
    cp bazel-bin/scripts/bazel-complete.bash output/
  '';

  # Build the CPP and Java examples to verify that Bazel works.

  doCheck = true;
  checkPhase = ''
    export TEST_TMPDIR=$(pwd)
    ./output/bazel test --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
  '';

  # Bazel expects gcc and java to be in the path.
  installPhase = ''
    mkdir -p $out/bin
    mv output/bazel $out/bin
    wrapProgram "$out/bin/bazel" --prefix PATH : "${lib.makeBinPath [ stdenv.cc jdk ]}"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  dontStrip = true;
  dontPatchELF = true;
}
