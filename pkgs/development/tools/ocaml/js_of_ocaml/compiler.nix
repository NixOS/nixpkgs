{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder
, cmdliner, cppo, yojson
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "js_of_ocaml-compiler is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "js_of_ocaml-compiler-${version}";
	version = "3.2.1";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "1v2hfq0ra9j07yz6pj6m03hrvgys4vmx0gclchv94yywpb2wc7ik";
	};

	buildInputs = [ ocaml findlib jbuilder cmdliner cppo ];

	propagatedBuildInputs = [ yojson ];

	buildPhase = "jbuilder build -p js_of_ocaml-compiler";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Compiler from OCaml bytecode to Javascript";
		license = stdenv.lib.licenses.gpl2;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
