{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "v${version}";
    hash = "sha256-jYyWPA/ifCtxujPZK7am6O0d/VpRW8hxGfd83wUtT6U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "svg2pdf-0.5.0" = "sha256-yBQpvDAnJ7C0PWIM/o0PzOg9JlDZCEiVdCTDDPSwrmE=";
      "typst-0.6.0" = "sha256-8e6BNffKgAUNwic4uEfDh77y2nIyYt9BwZr+ypv+d5A=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  patches = [
    # `rustPlatform.importCargoLock` has trouble parsing the `??` in the url
    ./remove-svg2pdf-patch.patch
  ];

  checkFlags = [
    # requires internet access
    "--skip=workspace::package::external::repo::test::full_download"
  ];

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
