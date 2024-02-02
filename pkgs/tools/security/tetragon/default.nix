{ lib, stdenv, fetchFromGitHub, pkg-config, go, llvm_16, clang_16, bash }:
let
  srcPath = "install/linux-tarball";
in
stdenv.mkDerivation rec {
  name = "tetragon";
  version = "v0.11.0";

  buildInputs = [pkg-config go llvm_16 clang_16];
  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    rev = "refs/tags/${version}";
    sha256 = "sha256-KOR5MMRnhrlcMPqRjzjSJXvitiZQ8/tlxEnBiQG2x/Q=";
  };

  buildPhase = ''
    export HOME=$TMP
    export LOCAL_CLANG=1
    export LOCAL_CLANG_FORMAT=1
    make tetragon
    make tetragon-operator
    make tetra
    NIX_CFLAGS_COMPILE="-fno-stack-protector -Qunused-arguments" make tetragon-bpf
  '';

  postPatch = ''
    substituteInPlace bpf/Makefile --replace '/bin/bash' '${bash}/bin/bash'
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/lib/tetragon
    sed -i "s+/usr/local/+$out/+g" ${srcPath}/usr/local/lib/tetragon/tetragon.conf.d/bpf-lib
    cp -n -r ${srcPath}/usr/local/lib/tetragon/tetragon.conf.d/ $out/lib/tetragon/
    cp -n -r ./bpf/objs $out/lib/tetragon/bpf
    mkdir -p $out/lib/tetragon/tetragon.tp.d/
    install -m755 -D ./tetra $out/bin/tetra
    install -m755 -D ./tetragon $out/bin/tetragon
  '';

  meta = with lib; {
    description = "Tetragon policy client.";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
