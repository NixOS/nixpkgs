{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
	pname = "obelisk";
	version = "0.4.0";
	src = fetchFromGitHub {
		owner = "lelio-brun";
		repo = "obelisk";
		rev = "v${version}";
		sha256 = "0rw85knbwqj2rys1hh5qy8sfdqb4mb1wsriy38n7zcpbwim47vb8";
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
