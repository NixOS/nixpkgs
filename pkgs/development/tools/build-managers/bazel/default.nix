{ stdenv, fetchFromGitHub, jdk, zip, zlib, protobuf2_5, pkgconfig, libarchive, unzip, which, makeWrapper }:

stdenv.mkDerivation rec {
  name = "bazel-20150326.981b7bc1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bazel";
    rev = "981b7bc1";
    sha256 = "0i9gxgqhfmix7hmkb15s7h9f8ssln08pixqm26pd1d20g0kfyxj7";
  };

  buildInputs = [ pkgconfig protobuf2_5 zlib zip jdk libarchive unzip which makeWrapper ];

  installPhase = ''
    PROTOC=protoc bash compile.sh
    mkdir -p $out/bin $out/share
    cp -R output $out/share/bazel
    ln -s $out/share/bazel/bazel $out/bin/bazel
    wrapProgram $out/bin/bazel --set JAVA_HOME "${jdk.home}"
  '';

  meta = {
    homepage = http://github.com/google/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.philandstuff ];
    platforms = [ "x86_64-linux" ];
  };
}
