{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, rustfmt
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-UPSh0/8HFaLvnU95Gyd+uQaRvWeXlp+HViVUKX0I1jI=";
  };

  cargoHash = "sha256-WYG2EkfEqjOOelxwivk5srtTNLxEPGX1ztwntvgft1I=";

  nativeBuildInputs = [
    pkg-config
    rustfmt
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  # Stop downloading from the Internet to
  # generate the Chrome Devtools Protocol
  DOCS_RS=true;

  # # Stop formating with rustfmt, pending version update for
  # # https://github.com/mdrokz/auto_generate_cdp/pull/8
  # # to remove rustfmt dependency
  # DO_NOT_FORMAT=true;

  # No test.
  doCheck = false;

  meta = with lib; {
    description = "A backend for mdBook written in Rust for generating PDF";
    mainProgram = "mdbook-pdf";
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 matthiasbeyer ];
  };
}
