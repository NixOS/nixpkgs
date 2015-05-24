{stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  #TODO add emacs support
  name = "racer-git-2015-05-18";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "c2d31ed49baa11f06ffc0c7bc8f95dd00037d035";
    sha256 = "0g420cbqpknhl61a4mpk3bbia8agf657d9vzzcqr338lmni80qz7";
  };

  depsSha256 = "0s951apqcr96lvc1jamk6qw3631gwnlnfgcx55vlznfm7shnmywn";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustc.src}/src"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
    install -d $out/share/emacs/site-lisp
    install "editors/"*.el $out/share/emacs/site-lisp
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.jagajaga ];
  };
}
