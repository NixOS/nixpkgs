{stdenv, fetchgit, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  #TODO add emacs support
  name = "racer-git-2015-05-04";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "bf2373ec08b0be03598283bd610c5b61bdb8738c";
    sha256 = "0ldf05d19ghxk3fslxrc87j18zg8bam2y0ygdy456h37y2p1d1ck";
  };

  patches = [ ./pr-232.patch ];

  depsSha256 = "0rinyh365znx39aygxyyxmi496pw0alblf2dl7l8fbmz63nkhfv2";

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
