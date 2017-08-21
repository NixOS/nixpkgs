{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-${version}";
  version = "2017-02-17";
  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "racerd";
    rev = "e3f3ff010fce2c67195750d9a6a669ffb3c2ac5f";
    sha256 = "125pmbkjnjh83xwikcwfbb8g150nldz7wh0ly1gv9kl1b521dydk";
  };

  doCheck = false;

  depsSha256 = "0db18m0vxzvg821gb5g8njhlnxw7im81m089i4982n8hmnhm1497";

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
