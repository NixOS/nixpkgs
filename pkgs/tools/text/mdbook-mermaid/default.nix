{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1neEuDsPMI4f1HaAP+Kx62RBW8hqqNThHpUNa5DzlnY=";
  };

  cargoSha256 = "sha256-Sk0cOLknS1UK3OcLHVSnA/H3BeMe7bpo2HgHEErQSAQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
