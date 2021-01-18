{ buildDunePackage, fetchFromGitHub, js_of_ocaml-compiler
, camlp4, ocsigen_deriving
}:

buildDunePackage rec {
  version = "3.2.1";
  pname = "js_of_ocaml-camlp4";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "js_of_ocaml";
    rev = version;
    sha256 = "1v2hfq0ra9j07yz6pj6m03hrvgys4vmx0gclchv94yywpb2wc7ik";
  };

  inherit (js_of_ocaml-compiler) meta;

  buildInputs = [ camlp4 ocsigen_deriving ];
}
