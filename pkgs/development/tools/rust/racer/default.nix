{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racer-${version}";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = "v${version}";
    sha256 = "1b6829nqx0sqw1akcid61izw8mah1dfx2nxldkmmg4scnydhvw1l";
  };

  depsSha256 = "1hfqr1kidl77lq3djbhfn37whvv6k0hg9g5gcnl6pgl6kn669hdc";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustc.src}/src"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
    install -d $out/share/emacs/site-lisp
    install "editors/emacs/"*.el $out/share/emacs/site-lisp
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
  };
}
