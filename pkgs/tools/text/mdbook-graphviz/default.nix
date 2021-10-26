{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wIgWaCjJrrajvUZbJjpx9P4urN2/eVo3+Za2NjTKWvM=";
  };

  cargoSha256 = "sha256-F8JuEk0ztB7jfcPNjU9vGsr3HLEJ2DmWGWxvdbLuyvQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  checkInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time.";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
