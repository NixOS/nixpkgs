{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, cacert
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4BIuD/rrA398hPEoNt5PwWylPAR0fA1UKc90xyH5Fd0=";
  };

  cargoHash = "sha256-ok+fjvwz4k0/M5j7wut2A2AK6tuO3UfZtgoCXaCaHXY=";

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

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dx --version | grep "dioxus ${version}"
  '';

  meta = with lib; {
    homepage = "https://dioxuslabs.com";
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio cathalmullan ];
    mainProgram = "dx";
  };
}
