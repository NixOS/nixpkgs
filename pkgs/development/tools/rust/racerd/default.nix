{ stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-${version}";
  version = "0.1.1";
  src = fetchgit {
    url = "git://github.com/jwilm/racerd.git";
    rev = "dcbb7885e84eb5e2fbb2072e185701ad1abbd93a";
    sha256 = "0qm0hpvxba632av355mj1wqd616zjvi0qy045np7mi746m0bbqwh";
  };

  doCheck = false;

  depsSha256 = "0ca0lc8mm8kczll5m03n5fwsr0540c2xbfi4nn9ksn0s4sap50yn";

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
