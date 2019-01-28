{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, cmdliner, cppo, yojson
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "js_of_ocaml-compiler is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "js_of_ocaml-compiler-${version}";
	version = "3.3.0";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "0bg8x2s3f24c8ia2g293ikd5yg0yjw3hkdgdql59c8k2amqin8f8";
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
