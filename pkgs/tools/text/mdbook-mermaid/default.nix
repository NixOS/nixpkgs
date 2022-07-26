{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Fd6TCmi1PnDJP2osMJNtEGzrI1Ay8s/XkhpzI+DLrGA=";
  };

  cargoSha256 = "sha256-W/HSPT7X5B4Gyg806H3nm0wWlF89gutW530dgZ/qJLo=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
