{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices }:

with lib;

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

  buildInputs = [ ocaml libelf ]
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
