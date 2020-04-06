{ lib, fetchFromGitHub, buildDunePackage
, ocaml, findlib, cmdliner, dune, cppo, yojson, ocaml-migrate-parsetree
}:

buildDunePackage rec {
	pname = "js_of_ocaml-compiler";
	version = "3.5.2";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "1fm855iavljx7rf9hii2qb7ky920zv082d9zlcl504by1bxp1yg8";
	};

	nativeBuildInputs = [ ocaml findlib dune cppo ];
  buildInputs = [ cmdliner ];

  configurePlatforms = [];
	propagatedBuildInputs = [ yojson ocaml-migrate-parsetree ];

	meta = {
		description = "Compiler from OCaml bytecode to Javascript";
		license = lib.licenses.gpl2;
		maintainers = [ lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
