{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
	name = "obelisk-${version}";
	version = "0.2.0";
	src = fetchFromGitHub {
		owner = "Lelio-Brun";
		repo = "Obelisk";
		rev = "v${version}";
		sha256 = "0qkxnv25rmqj7qhnw1fav88kr73ax9fjbzvkrwximz5477gjxx3p";
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
