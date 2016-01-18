{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racer-${version}";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = "v${version}";
    sha256 = "1y6xzavxm5bnqcnnz0mbnf2491m2kksp36yx3kd5mxyly33482y7";
  };

  depsSha256 = "1r2fxirkc0y6g7aas65n3yg1f2lf3kypnjr2v20p5np2lvla6djj";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustc.src}/src"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
  };
}
