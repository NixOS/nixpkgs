{ stdenv, fetchFromGitHub, ocaml, findlib, dune, js_of_ocaml-compiler
, camlp4, ocsigen_deriving
}:

stdenv.mkDerivation rec {
	version = "3.2.1";
	name = "js_of_ocaml-camlp4-${version}"; 

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "1v2hfq0ra9j07yz6pj6m03hrvgys4vmx0gclchv94yywpb2wc7ik";
	};

	inherit (js_of_ocaml-compiler) installPhase meta;

	buildInputs = [ ocaml findlib dune camlp4 ocsigen_deriving ];

	buildPhase = "dune build -p js_of_ocaml-camlp4";
}
