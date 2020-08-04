{ lib, fetchurl, buildDunePackage
, ocaml, findlib, cmdliner, dune_2, cppo, yojson, ocaml-migrate-parsetree
}:

buildDunePackage rec {
	pname = "js_of_ocaml-compiler";
	version = "3.6.0";
	useDune2 = true;

	src = fetchurl {
		url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
		sha256 = "51eaa89c83ef3168ef270bf7997cbc35a747936d3f51aa6fac58fb0323b4cbb0";
	};

	nativeBuildInputs = [ ocaml findlib dune_2 cppo ];
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
