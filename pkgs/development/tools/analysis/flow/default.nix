{ stdenv, fetchFromGitHub, ocaml, libelf }:

stdenv.mkDerivation rec {
  version = "0.17.0";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1hc4gspxp43svr36l4fn4fpd7d9myg8hf5hph5y1lq9ihqaiymsp";
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
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
