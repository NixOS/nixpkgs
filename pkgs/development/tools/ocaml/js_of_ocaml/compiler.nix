{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, cmdliner, cppo, yojson
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "js_of_ocaml-compiler is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "js_of_ocaml-compiler-${version}";
	version = "3.2.0";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "0dxxdxgrbg9xvvi3i627krnk6rb1ja0ypp2diwdkpnmy45wak9lv";
	};

	buildInputs = [ ocaml findlib dune cmdliner cppo ];

	propagatedBuildInputs = [ yojson ];

	buildPhase = "dune build -p js_of_ocaml-compiler";

	inherit (dune) installPhase;

	meta = {
		description = "Compiler from OCaml bytecode to Javascript";
		license = stdenv.lib.licenses.gpl2;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
