{stdenv, fetchgit, rustc, cargo, makeWrapper }:

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2015-04-12";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "5437e2074d87dfaab75a0f1bd2597bed61c0bbf1";
    sha256 = "0a768gvjry86l0xa5q0122iyq7zn2h9adfniglsgrbs4fan49xyn";
  };

  buildInputs = [ rustc cargo makeWrapper ];

  buildPhase = ''
    CARGO_HOME="$NIX_BUILD_TOP/.cargo" cargo build --release
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
