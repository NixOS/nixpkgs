{ stdenv, fetchurl, jdk, zip, unzip, bash, makeWrapper, which, coreutils }:

stdenv.mkDerivation rec {

  version = "0.5.3";

  meta = with stdenv.lib; {
    homepage = http://github.com/bazelbuild/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = platforms.linux;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "04jj0w9bkkmshb5qrv4d345lz4m9qiq1pmc5z1q6zk1wpf3pxlnn";
  };

  sourceRoot = ".";

  # bazel expects bash to find coreutils when starting from an empty environment
  postPatch = ''
    makeWrapper "${bash}/bin/bash" "$out/bin/bash" --argv0 '$0' --prefix PATH : ${coreutils}/bin

    for f in $(grep -l -r '#!/bin/bash'); do
      substituteInPlace "$f" --replace '#!/bin/bash' '#!'$out/bin/bash
    done
    for f in \
      src/main/java/com/google/devtools/build/lib/analysis/CommandHelper.java \
      src/main/java/com/google/devtools/build/lib/bazel/rules/BazelConfiguration.java \
      src/main/java/com/google/devtools/build/lib/bazel/rules/sh/BazelShRuleClasses.java \
      src/main/java/com/google/devtools/build/lib/rules/cpp/LinkCommandLine.java \
      ; do
      substituteInPlace "$f" --replace /bin/bash $out/bin/bash
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
