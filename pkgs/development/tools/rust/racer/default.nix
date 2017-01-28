{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.5";
  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = "93eac5cd633c937a05d4138559afe6fb054c7c28";
    sha256 = "0smp5dv0f5bymficrg0dz8h9x4lhklrz6f31fbcy0vhg8l70di2n";
  };

  depsSha256 = "1qq2fpjg1wfb7z2s8p4i2aw9swcpqsp9m5jmhbyvwnd281ag4z6a";

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
