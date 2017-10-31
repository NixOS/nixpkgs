{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices, findlib, camlp4, sedlex, ocamlbuild }:

with lib;

stdenv.mkDerivation rec {
  version = "0.57.3";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "0pmgj2mv4pmgw8slh4gdj7jskcgxbdsy09arh5rnwf0byy81fky6";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf findlib camlp4 sedlex ocamlbuild ]
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
