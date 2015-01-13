{stdenv, fetchgit, rustc, makeWrapper }:

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2015-01-07";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "bf73c05ac719cd3b0f8d8f9e0ecb066ede6aa9d9";
    sha256 = "1159fsfca2kqvlajp8sawrskip7hc0rppk8vhwxa2vw8zznp56w0";
  };

  buildInputs = [ rustc makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p bin/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs.";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.jagajaga ];
  };
}
