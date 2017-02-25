{ stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-${version}";
  version = "2016-12-24";
  src = fetchgit {
    url = "git://github.com/jwilm/racerd.git";
    rev = "dc090ea11d550cd513416d21227d558dbfd2fcb6";
    sha256 = "0jfryb1b32m6bn620gd7y670cfipaswj1cppzkybm4xg6abqh07b";
  };

  doCheck = false;

  depsSha256 = "1vv6fyisi11bcajxkq3ihpl59yh504xmnsr222zj15hmivn0jwf2";

  buildInputs = [ makeWrapper ];

  RUST_SRC_PATH = ''${rustPlatform.rust.rustc.src}/src'';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racerd $out/bin/
    wrapProgram $out/bin/racerd --set RUST_SRC_PATH "$RUST_SRC_PATH"
  '';

  meta = with stdenv.lib; {
    description = "JSON/HTTP Server based on racer for adding Rust support to editors and IDEs";
    homepage = "https://github.com/jwilm/racerd";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
