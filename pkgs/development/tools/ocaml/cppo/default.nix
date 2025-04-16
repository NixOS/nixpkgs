{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  ocamlbuild,
  buildDunePackage,
}:

let
  pname = "cppo";

  meta = with lib; {
    description = "C preprocessor for OCaml";
    mainProgram = "cppo";
    longDescription = ''
      Cppo is an equivalent of the C preprocessor targeted at the OCaml language and its variants.
    '';
    homepage = "https://github.com/ocaml-community/${pname}";
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };

in

if lib.versionAtLeast ocaml.version "4.02" then

  buildDunePackage rec {
    inherit pname;
    version = "1.8.0";

    src = fetchFromGitHub {
      owner = "ocaml-community";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-+HnAGM+GddYJK0RCvKrs+baZS+1o8Yq+/cVa3U3nFWg=";
    };

    doCheck = true;

    inherit meta;
  }

else

  let
    version = "1.5.0";
  in

  stdenv.mkDerivation {

    name = "${pname}-${version}";

    src = fetchFromGitHub {
      owner = "mjambon";
      repo = pname;
      rev = "v${version}";
      sha256 = "1xqldjz9risndnabvadw41fdbi5sa2hl4fnqls7j9xfbby1izbg8";
    };

    strictDeps = true;

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
    ];

    inherit meta;

    createFindlibDestdir = true;

    makeFlags = [ "PREFIX=$(out)" ];

    preBuild = ''
      mkdir -p $out/bin
    '';

  }
