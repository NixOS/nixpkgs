{ stdenv, fetchurl, jdk, zip, unzip, which, bash, binutils, perl }:

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

  patches = [ ./bin_to_env.patch ];

  postPatch = ''
    patchShebangs ./compile.sh
    for d in scripts src/java_tools src/test src/tools third_party/ijar/test tools; do
      patchShebangs $d
    done
  '';

  buildInputs = [
    stdenv.cc
    stdenv.cc.cc.lib
    bash
    jdk
    zip
    unzip
    which
    binutils
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
    ./output/bazel test examples/cpp:hello-success_test
    ./output/bazel test examples/java-native/src/test/java/com/example/myproject:hello
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv output/bazel $out/bin
  '';

  dontStrip = true;
  dontPatchELF = true;
}
