{ stdenv, fetchurl, jdk, zip, unzip, which, bash, binutils, coreutils }:

stdenv.mkDerivation rec {

  version = "0.4.4";

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
    sha256 = "1fwfahkqi680zyxmdriqj603lpacyh6cg6ff25bn9bkilbfj2anm";
  };

  sourceRoot = ".";

  postPatch = ''
    patchShebangs .
    for f in \
      src/main/java/com/google/devtools/build/lib/analysis/CommandHelper.java \
      src/main/java/com/google/devtools/build/lib/bazel/rules/BazelConfiguration.java \
      src/test/java/com/google/devtools/build/lib/shell/CommandTest.java \
      src/test/java/com/google/devtools/build/lib/shell/InterruptibleTest.java \
      src/test/java/com/google/devtools/build/lib/shell/LoadTest.java \
      src/test/java/com/google/devtools/build/lib/skylark/SkylarkRuleImplementationFunctionsTest.java \
      src/test/java/com/google/devtools/build/lib/standalone/StandaloneSpawnStrategyTest.java
    do
      substituteInPlace $f \
        --replace /bin/bash ${bash}/bin/bash \
        --replace /bin/cat ${coreutils}/bin/cat \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace /bin/false ${coreutils}/bin/false \
        --replace /bin/pwd ${coreutils}/bin/pwd \
        --replace /bin/sleep ${coreutils}/bin/sleep \
        --replace /bin/true ${coreutils}/bin/true
    done
  '';

  buildInputs = [
    stdenv.cc
    stdenv.cc.cc.lib
    jdk
    zip
    unzip
    which
    binutils
  ];

  # These must be propagated since the dependency is hidden in a compressed
  # archive.

  propagatedBuildInputs = [
    bash
    coreutils
  ];

  # If TMPDIR is in the unpack dir we run afoul of blaze's infinite symlink
  # detector (see com.google.devtools.build.lib.skyframe.FileFunction).
  # Change this to $(mktemp -d) as soon as we figure out why.

  buildPhase = ''
    export TMPDIR=/tmp
    ./compile.sh
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
  '';

  dontStrip = true;
  dontPatchELF = true;
}
