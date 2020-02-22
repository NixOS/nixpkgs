{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, dune }:
let
  pname = "cppo";
  webpage = "https://github.com/ocaml-community/${pname}";
in
assert stdenv.lib.versionAtLeast ocaml.version "3.12";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "1.6.5";
    sha256 = "03c0amszy28shinvz61hm340jz446zz5763a1pdqlza36kwcj0p0";
    buildInputs = [ dune ];
    extra = {
      inherit (dune) installPhase;
    };
  } else {
    version = "1.5.0";
    sha256 = "1xqldjz9risndnabvadw41fdbi5sa2hl4fnqls7j9xfbby1izbg8";
    extra = {
      createFindlibDestdir = true;
      makeFlags = [ "PREFIX=$(out)" ];
      preBuild = ''
        mkdir $out/bin
      '';
    };
  }
; in

stdenv.mkDerivation ({

  name = "${pname}-${param.version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = "v${param.version}";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ] ++ (param.buildInputs or []);

  meta = with stdenv.lib; {
    description = "The C preprocessor for OCaml";
    longDescription = ''
      Cppo is an equivalent of the C preprocessor targeted at the OCaml language and its variants.
    '';
    homepage = webpage;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
} // param.extra)
