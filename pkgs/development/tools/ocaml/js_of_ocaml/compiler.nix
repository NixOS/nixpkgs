{ lib, fetchFromGitHub, buildDunePackage
, ocaml, findlib, cmdliner, dune, cppo, yojson
}:

buildDunePackage rec {
	pname = "js_of_ocaml-compiler";
	version = "3.4.0";

	src = fetchFromGitHub {
		owner = "ocsigen";
		repo = "js_of_ocaml";
		rev = version;
		sha256 = "0c537say0f3197zn8d83nrihabrxyn28xc6d7c9c3l0vvrv6qvfj";
	};

	nativeBuildInputs = [ ocaml findlib dune cppo ];
  buildInputs = [ cmdliner ];

  configurePlatforms = [];
	propagatedBuildInputs = [ yojson ];

	meta = {
		description = "Compiler from OCaml bytecode to Javascript";
		license = lib.licenses.gpl2;
		maintainers = [ lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
