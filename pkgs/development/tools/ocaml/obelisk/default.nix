{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
	name = "obelisk-${version}";
	version = "0.2.0";
	src = fetchFromGitHub {
		owner = "Lelio-Brun";
		repo = "Obelisk";
		rev = "v${version}";
		sha256 = "0kbadib53x7mzqri9asd8fmhl4xfgk4ajgzd7rlq3irf2j3bmcqp";
	};

	buildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild menhir ];

	installFlags = [ "BINDIR=$(out)/bin" ];

	meta = {
		description = "A simple tool which produces pretty-printed output from a Menhir parser file (.mly)";
		license = stdenv.lib.licenses.mit;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocamlPackages.ocaml.meta) platforms;
	};
}
