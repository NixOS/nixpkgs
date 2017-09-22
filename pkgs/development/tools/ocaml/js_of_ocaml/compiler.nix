{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder
, cmdliner, cppo, yojson
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "js_of_ocaml-compiler is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "js_of_ocaml-compiler-${version}";
	version = "3.0.0";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "17w1pqjk521jd4yp34miyif0cxjxchnw59xhj188qfl635ykb4k8";
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
