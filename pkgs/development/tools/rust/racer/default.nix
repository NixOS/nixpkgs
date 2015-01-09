{stdenv, fetchgit, rust, makeWrapper }:

let
  rustSrc = rust.src;
in

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2014-12-04";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "bf73c05ac719cd3b0f8d8f9e0ecb066ede6aa9d9";
    sha256 = "1159fsfca2kqvlajp8sawrskip7hc0rppk8vhwxa2vw8zznp56w0";
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
