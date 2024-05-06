{ lib
, stdenv
, makeWrapper
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
    makeWrapper
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

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/age-plugin-yubikey \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pcsclite ]} \
  '';

  meta = with lib; {
    description = "YubiKey plugin for age";
    mainProgram = "age-plugin-yubikey";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    changelog = "https://github.com/str4d/age-plugin-yubikey/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ kranzes vtuan10 ];
  };
}
