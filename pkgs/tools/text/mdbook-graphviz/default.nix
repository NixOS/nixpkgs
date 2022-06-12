{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HTHGb23wc10iAWXX/TNMXjTLWm+OSf1WWW1+/aQRcsk=";
  };

  cargoSha256 = "sha256-7z/4brKY9vpic8mv1b4P/8DE+VyColYnPPoPmY9891M=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  checkInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time.";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
