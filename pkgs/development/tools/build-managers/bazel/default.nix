{ stdenv, fetchurl, jdk, zip, unzip, bash, makeWrapper, which }:

stdenv.mkDerivation rec {

  version = "0.4.5";

  meta = with stdenv.lib; {
    homepage = https://github.com/bazelbuild/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = platforms.linux;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "0asmq3kxnl4326zhgh13mvcrc8jvmiswjj4ymrq0943q4vj7nwrb";
  };

  sourceRoot = ".";

  postPatch = ''
    for f in $(grep -l -r '#!/bin/bash'); do
      substituteInPlace "$f" --replace '#!/bin/bash' '#!${bash}/bin/bash'
    done
    for f in \
      src/main/java/com/google/devtools/build/lib/analysis/CommandHelper.java \
      src/main/java/com/google/devtools/build/lib/bazel/rules/BazelConfiguration.java \
      src/main/java/com/google/devtools/build/lib/bazel/rules/sh/BazelShRuleClasses.java \
      src/main/java/com/google/devtools/build/lib/rules/cpp/LinkCommandLine.java \
      ; do
      substituteInPlace "$f" --replace /bin/bash ${bash}/bin/bash
    done
  '';

  buildInputs = [
    stdenv.cc
    stdenv.cc.cc.lib
    jdk
    zip
    unzip
    makeWrapper
    which
  ];

  # These must be propagated since the dependency is hidden in a compressed
  # archive.

  propagatedBuildInputs = [
    bash
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
    wrapProgram "$out/bin/bazel" --prefix PATH : "${stdenv.cc}/bin:${jdk}/bin"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  dontStrip = true;
  dontPatchELF = true;
}
