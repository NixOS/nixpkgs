{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, rustfmt
, cacert
, openssl
, darwin
, testers
, dioxus-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.5.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cOd8OGkmebUYw6fNLO/kja81qKwqBuVpJqCix1Izf64=";
  };

  cargoHash = "sha256-shllaNdg9g6fD8qRyCKpN47keFUTu0g96MzVX4BrhXI=";

  nativeBuildInputs = [ pkg-config cacert ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  OPENSSL_NO_VENDOR = 1;

  nativeCheckInputs = [ rustfmt ];

  checkFlags = [
    # requires network access
    "--skip=server::web::proxy::test::add_proxy"
    "--skip=server::web::proxy::test::add_proxy_trailing_slash"
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
