{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racer-${version}";
  version = "1.2.10-master-160831";
  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = "a1ebc93b96e80ab62d830c32d5446b9f43eb6d30";
    sha256 = "1vv4kziha4jbhnfmk8pcalb5dwiga7p1a2qfyf5yinx998g6rdpd";
  };

  depsSha256 = "0f8wj76yrxzizk8z3zffwqrz52waf2vl9qschma6ndidqbbpxwf7";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rust.rustc.src}/src"
  '';

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustPlatform.rust.rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
