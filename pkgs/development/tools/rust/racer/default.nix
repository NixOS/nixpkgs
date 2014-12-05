{stdenv, fetchgit, rust, makeWrapper }:

let
  rustSrc = rust.src;
in

stdenv.mkDerivation rec {
  #TODO add emacs support
  name = "racer-git-2014-11-24";
  src = fetchgit {
    url = https://github.com/phildawes/racer;
    rev = "50655ffd509bea09ea9b310970dedfeaf5a33cf3";
    sha256 = "0bd456i4nz12z39ljnw1kjg8mcflvm7rjql2r80fb038c7rd6xi1";
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
