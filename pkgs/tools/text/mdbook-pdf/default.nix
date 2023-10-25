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
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3hyvLLBcS7MLAL707tkvW8LGue/x9DudOYhJDDqAdRg=";
  };

  cargoHash = "sha256-ecIaKSrkqUsQWchkm9uCTXLuQabzGmEz1UqDR13vX8Y=";

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
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
  };
}
