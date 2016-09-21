{ stdenv, fetchFromGitHub, jdk, zip, zlib, protobuf3_0, pkgconfig, libarchive, unzip, which, makeWrapper }:
stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "bazel-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bazel";
    rev = version;
    sha256 = "1cm8zjxf8y3ai6h9wndxvflfsijjqhg87fll9ar7ff0hbbbdf6l5";
  };

  buildInputs = [ pkgconfig protobuf3_0 zlib zip libarchive unzip which makeWrapper jdk ];

  buildPhase = ''
    export LD_LIBRARY_PATH="${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"

    bash compile.sh
  '';

  installPhase = ''
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
