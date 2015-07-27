{ stdenv, fetchFromGitHub, ocaml, libelf }:

stdenv.mkDerivation rec {
  version = "0.13.1";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1p7rzhvmz9y7ii2z05mfdb49i45f82kx8c9ywciwqma06zycvd80";
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
