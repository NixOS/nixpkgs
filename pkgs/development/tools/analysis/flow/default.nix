{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices, findlib, camlp4, sedlex, ocamlbuild, ocaml_lwt }:

with lib;

stdenv.mkDerivation rec {
  version = "0.61.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "0742hcg97gw6zsvm5j30rfyj71n71pfag3vcmjdh7yamn8gpn8ga";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf findlib camlp4 sedlex ocamlbuild ocaml_lwt ]
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
