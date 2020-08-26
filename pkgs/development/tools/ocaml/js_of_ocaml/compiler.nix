{ lib, fetchurl, buildDunePackage
, ocaml, findlib, cmdliner, dune_2, cppo, yojson, ocaml-migrate-parsetree
, menhir
}:

buildDunePackage rec {
	pname = "js_of_ocaml-compiler";
	version = "3.7.0";
	useDune2 = true;

	src = fetchurl {
		url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
		sha256 = "0rw6cfkl3zlyav8q2w7grxxqjmg35mz5rgvmkiqb58nl4gmgzx6w";
	};

	nativeBuildInputs = [ ocaml findlib dune_2 cppo menhir ];
  buildInputs = [ cmdliner ];

  configurePlatforms = [];
	propagatedBuildInputs = [ yojson ocaml-migrate-parsetree ];

	meta = {
		description = "Compiler from OCaml bytecode to Javascript";
		license = lib.licenses.gpl2;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://ocsigen.org/js_of_ocaml/";
	};
}
