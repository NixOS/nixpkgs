{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dXeu/e92lafurA/bqKoszIjK/3qw/ZvVKnDxYALRpTk=";
  };

  cargoSha256 = "sha256-LVfeQPRpwv1l3Brm8HJYoYvv26fJhsfR4I9Ds4NuWQM=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
