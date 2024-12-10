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
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bAo3098QxepKbvBb9uF6iGNW0+RAKCCMyWfuG5WyREo=";
  };

  cargoHash = "sha256-YGGmzdcy3x4RF1S8jMPXTAglThlfG7nZTD0IATGvePw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    CoreFoundation
    CoreServices
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan matthiasbeyer ];
  };
}
