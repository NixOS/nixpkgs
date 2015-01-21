{stdenv, fetchgit, rustc, cargo, makeWrapper }:

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2015-01-20";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "599aa524ea949ec5f9f0be0375dbb1df9cb852ae";
    sha256 = "1kasm7vffn176wr072m1dmqg1rb3wqai9yisxf8mia62548pdx88";
  };

  buildInputs = [ rustc cargo makeWrapper ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs.";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.jagajaga ];
  };
}
