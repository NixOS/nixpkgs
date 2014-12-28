{stdenv, fetchgit, rust, makeWrapper }:

let
  rustSrc = rust.src;
in

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2014-12-04";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "cc633ad2477cb064ba6e4d23b58c124c8521410c";
    sha256 = "1nqlgdqnqhzbnbxvhs60gk5hjzrxfq8blyh1riiknxdlq5kqaky7";
  };

  buildInputs = [ rust makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p bin/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustSrc}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide rust code completion for editors and IDEs.";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.jagajaga ];
  };
}
