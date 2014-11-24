{ stdenv, fetchFromGitHub, ocaml, libelf }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1f33zmajd6agb36gp8bwj0yqihjhxnkpig9x3a4ggn369x6ixhn3";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf ];

  meta = with stdenv.lib; {
    homepage = "http://flowtype.org/";
    description = "A static type checker for JavaScript";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
