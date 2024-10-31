{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, pcsclite
, PCSC
, Foundation
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-yubikey";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9ghnPe83K+qixaFKCdM2FCPoENTNJnZA+OmmpD0E5LE=";
  };

  cargoHash = "sha256-8petNuCJ1qS6XKt+24Lg/bZh96yj9oO6fu/z65Xhi4k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux pcsclite
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    Foundation
    PCSC
  ];

  meta = with lib; {
    description = "YubiKey plugin for age";
    mainProgram = "age-plugin-yubikey";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    changelog = "https://github.com/str4d/age-plugin-yubikey/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ kranzes vtuan10 ];
  };
}
