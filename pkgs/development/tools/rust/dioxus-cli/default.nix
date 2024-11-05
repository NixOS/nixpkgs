{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, rustfmt
, cacert
, openssl
, darwin
, nix-update-script
, testers
, dioxus-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.5.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/LeMh5WX4dvkveu5w6qBQLbtoi5yUW6iad0YatA/tMQ=";
  };

  cargoHash = "sha256-D6y2NiFqSf0u6icSKCRZK7ycR+GswOX627M7PEy/D6U=";

  nativeBuildInputs = [ pkg-config cacert ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = dioxus-cli; };
  };

  meta = with lib; {
    homepage = "https://dioxuslabs.com";
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio cathalmullan ];
    mainProgram = "dx";
  };
}
