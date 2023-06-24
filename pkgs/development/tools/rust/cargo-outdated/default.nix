{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, curl
, CoreFoundation
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-u8VMVW2LJcwDRv43705aOcP0WMRfB3hakdgufYuI7I4=";
  };

  cargoHash = "sha256-rXLgNzbzMZG+nviAnK9n7ISWuNOPMugubHNMwJRKRZc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    curl
    CoreFoundation
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan ];
  };
}
