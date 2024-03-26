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
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "narrowlink";
    repo = "narrowlink";
    rev = version;
    hash = "sha256-Ro5SfcuKy0JqSwh2HbYisE9I4BTP4o7qjEA3fU3pAuw=";
  };

  cargoHash = "sha256-XHbgwqvzfnpbu2h8rbI8XsL+og0gkjQzhHzME6crmZg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "A self-hosted solution to enable secure connectivity between devices across restricted networks like NAT or firewalls";
    homepage = "https://github.com/narrowlink/narrowlink";
    license = with lib.licenses; [ agpl3Only mpl20 ]; # the gateway component is AGPLv3, the rest is MPLv2
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "narrowlink";
  };
}
