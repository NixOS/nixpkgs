{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HTHGb23wc10iAWXX/TNMXjTLWm+OSf1WWW1+/aQRcsk=";
  };

  cargoPatches = [
    # Remove when updating mdbook-graphviz past 0.1.4.
    ./update-mdbook-for-rust-1.64.patch
  ];

  cargoHash = "sha256-keDyfXooPU/GOx56OTq5psDohfZ0E478bnWn0bbC29o=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time.";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
