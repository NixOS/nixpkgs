{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:
let
  pname = "cppo";
  version = "1.5.0";
  webpage = "http://mjambon.com/${pname}.html";
in
assert stdenv.lib.versionAtLeast ocaml.version "3.12";
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xqldjz9risndnabvadw41fdbi5sa2hl4fnqls7j9xfbby1izbg8";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  makeFlags = "PREFIX=$(out)";

  preBuild = ''
    mkdir $out/bin
  '';

  meta = with stdenv.lib; {
    description = "The C preprocessor for OCaml";
    longDescription = ''
      Cppo is an equivalent of the C preprocessor targeted at the OCaml language and its variants.
    '';
    homepage = "${webpage}";
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
