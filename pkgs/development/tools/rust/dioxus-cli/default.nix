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
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-h2l6SHty06nLNbdlnSzH7I4XY53yyxNbx663cHYmPG0=";
  };

  cargoHash = "sha256-3pFkEC1GAJmTqXAymX4WRIq7EEtY17u1TCg+OhqL3bA=";

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
