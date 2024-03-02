{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, curl
, CoreFoundation
, CoreServices
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rbfCrq9AwjrynNSklR1un3BUGv0kblwIxy72lTjEDVc=";
  };

  cargoHash = "sha256-kBolewLzKGq3rmSeWlLMDqKb4QQfWf3J6DnXTB0SV54=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    curl
    CoreFoundation
    CoreServices
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan matthiasbeyer ];
  };
}
