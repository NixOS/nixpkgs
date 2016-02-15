{ stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-2016-01-12";

  src = fetchgit {
    url = "git://github.com/jwilm/racerd.git";
    rev = "57c9b09ef87d64c0221790d8bcc716014f926ea2";
    sha256 = "5d078b5827f5023cea18282cbbf09976104b8cd25fc0e6933f4cb8cbedd063b3";
  };


  depsSha256 = "00j0b5i17piyfynz16b9s0z4n6rh2qkhicqdz7b5k5k0az4rxc1x";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustc.src}/src"
  '';

  checkPhase = '' echo nope '';

  installPhase = ''
    mkdir -p $out/lib/ycmd/third_party/racerd/target/release/
    cp -p target/release/racerd $out/lib/ycmd/third_party/racerd/target/release/
    wrapProgram $out/lib/ycmd/third_party/racerd/target/release/racerd --set RUST_SRC_PATH "${rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "JSON/HTTP Server based on racer for adding Rust support to editors and IDEs";
    homepage = "https://github.com/jwilm/racerd";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
  };
}
