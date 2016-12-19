{ stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racerd-${version}";
  version = "2016-08-23";
  src = fetchgit {
    url = "git://github.com/jwilm/racerd.git";
    rev = "5d685ed26ba812a1afe892a8c0d12eb6abbeeb3d";
    sha256 = "1ww96nc00l8p28rnln31n92x0mp2p5jnaqh2nwc8xi3r559p1y5i";
  };

  doCheck = false;

  depsSha256 = "13vkabr6bbl2nairxpn3lhqxcr3larasjk03r4hzrn7ff7sy40h2";

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
