{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
	name = "obelisk-${version}";
	version = "0.3.0";
	src = fetchFromGitHub {
		owner = "lelio-brun";
		repo = "obelisk";
		rev = "v${version}";
		sha256 = "12gldzi1mp15vwkk6llz2ignpc8ndqlycm88njb4k7r9hpv59m97";
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
