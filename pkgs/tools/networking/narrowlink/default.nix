{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "narrowlink";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "narrowlink";
    repo = "narrowlink";
    rev = version;
    hash = "sha256-vef7ctauSl0xfYNqjvl8wLGbqzzkMItz1O7sT1UZ4b0=";
  };

  # Cargo.lock is outdated
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoHash = "sha256-craOunscE6o8PXtZFCYpkFH/amkuLOK7SrV+XHbS2GM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
    darwin.apple_sdk_11_0.frameworks.Security
  ];

  meta = {
    description = "Narrowlink securely connects devices and services together, even when both nodes are behind separate NAT";
    homepage = "https://github.com/narrowlink/narrowlink";
    license = with lib.licenses; [ agpl3Only mpl20 ]; # the gateway component is AGPLv3, the rest is MPLv2
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
