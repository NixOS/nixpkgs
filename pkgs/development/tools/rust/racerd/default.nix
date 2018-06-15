{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-${version}";
  version = "2017-09-15";
  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "racerd";
    rev = "29cd4c6fd2a9301e49931c2e065b2e10c4b587e4";
    sha256 = "0knz881mjhd8q2i8ydggaa7lfpiqy11wjmnv5p80n1d8zca6yb7z";
  };

  doCheck = false;

  cargoSha256 = "00gxj98zdkbrc5cxd4w5hk7iwv9a1kwa535hhspx9xd02r4d8rzl";

  buildInputs = [ makeWrapper ];

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racerd $out/bin/
    wrapProgram $out/bin/racerd --set RUST_SRC_PATH "$RUST_SRC_PATH"
  '';

  meta = with stdenv.lib; {
    description = "JSON/HTTP Server based on racer for adding Rust support to editors and IDEs";
    homepage = https://github.com/jwilm/racerd;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
