{stdenv, fetchgit, rustc, cargo, makeWrapper }:

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2015-02-28";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "2e1d718fae21431de4493c238196466e9d4996bc";
    sha256 = "0lvp494kg2hlbbdrwxmmxkyhjw53y9wjdml9z817pwj3fwmrjsx0";
  };

  buildInputs = [ rustc cargo makeWrapper ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
    install -d $out/share/emacs/site-lisp
    install "editors/"*.el $out/share/emacs/site-lisp
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs.";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.jagajaga ];
  };
}
