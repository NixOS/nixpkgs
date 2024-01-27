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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V3NzZyCfslUBsARO5UC8N+cuptLxg2euM87DGqtLpPk=";
  };

  cargoHash = "sha256-5qmwCcrhDkJlyeTS+waMiTxro1HjMHiQE5Ds/4sVpx4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.isLinux pcsclite
  ++ lib.optionals stdenv.isDarwin [
    IOKit
    Foundation
    PCSC
  ];

  meta = with lib; {
    description = "YubiKey plugin for age";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    changelog = "https://github.com/str4d/age-plugin-yubikey/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ kranzes vtuan10 ];
  };
}
