{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, cacert
, openssl
, darwin
, testers
, dioxus-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.4.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TWcuEobYH2xpuwB1S63HoP/WjH3zHXTnlXXvOcYIZG8=";
  };

  cargoHash = "sha256-ozbGK46uq3qXZifyTY7DDX1+vQuDJuSOJZw35vwcuxY=";

  nativeBuildInputs = [ pkg-config cacert ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  OPENSSL_NO_VENDOR = 1;

  checkFlags = [
    # requires network access
    "--skip=server::web::proxy::test::add_proxy"
    "--skip=server::web::proxy::test::add_proxy_trailing_slash"
  ];

  # Omitted: --doc
  # Can be removed after 0.4.3 or when https://github.com/DioxusLabs/dioxus/pull/1706 is resolved
  # Matches upstream package test CI https://github.com/DioxusLabs/dioxus/blob/544ca5559654c8490ce444c3cbd85c1bfb8479da/Makefile.toml#L94-L108
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--tests"
    "--examples"
  ];

  passthru.tests.version = testers.testVersion {
    package = dioxus-cli;
    command = "${meta.mainProgram} --version";
    inherit version;
  };

  meta = with lib; {
    homepage = "https://dioxuslabs.com";
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio cathalmullan ];
    mainProgram = "dx";
  };
}
