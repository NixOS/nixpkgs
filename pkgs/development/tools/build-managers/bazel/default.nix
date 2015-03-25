{ stdenv, fetchFromGitHub, jdk, zip, zlib, protobuf, pkgconfig, libarchive, unzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "bazel-20150325.9a0dc1b2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bazel";
    rev = "9a0dc1b2";
    sha256 = "1bgx12bnrqxz720ljn7kdzd4678p4mxldiylll3h0v5673vgrf5p";
  };

  buildInputs = [ pkgconfig protobuf zlib zip jdk libarchive unzip makeWrapper ];

  installPhase = ''
    PROTOC=protoc bash compile.sh
    mkdir -p $out/bin $out/share
    cp -R output $out/share/bazel
    ln -s $out/share/bazel/bazel $out/bin/bazel
    wrapProgram $out/bin/bazel --set JAVA_HOME "${jdk}"
  '';

  meta = {
    homepage = http://github.com/google/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = stdenv.lib.licenses.asl20;
  };
}
