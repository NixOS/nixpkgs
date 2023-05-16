<<<<<<< HEAD
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
=======
{ lib, fetchCrate, rustPlatform, openssl, pkg-config, stdenv, CoreServices }:
rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SnmDOMxc+39LX6kOzma2zA6T91UGCnvr7WWhX+wXnLo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoSha256 = "sha256-Mf/WtOO/vFuhg90DoPDwOZ6XKj423foHZ8vHugXakb0=";

  meta = with lib; {
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    homepage = "https://dioxuslabs.com";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
