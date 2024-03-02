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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "narrowlink";
    repo = "narrowlink";
    rev = version;
    hash = "sha256-priVl44VSxV+rCy/5H704I3CbNXDMP2BUguknl5Bguk=";
  };

  cargoHash = "sha256-q15T0/2Xf8L6ZEphIjZzzcqcnkWMbv3zvBAd/Ofvnfg=";

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
