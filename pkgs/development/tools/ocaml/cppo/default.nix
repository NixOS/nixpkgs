{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild
, buildDunePackage
}:

let
  pname = "cppo";

  meta = with lib; {
    description = "The C preprocessor for OCaml";
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
  version = "1.6.9";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NdN2QnVRfRq9hEcSAnO2Wha7icDlf2Zg4JQqoEWmErE=";
  };

  doCheck = true;

  inherit meta;
}

else

let version = "1.5.0"; in

stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xqldjz9risndnabvadw41fdbi5sa2hl4fnqls7j9xfbby1izbg8";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  inherit meta;

  createFindlibDestdir = true;

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    mkdir -p $out/bin
  '';

}
