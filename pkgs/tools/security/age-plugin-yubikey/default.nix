{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, pcsclite
, PCSC
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-yubikey";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b7/65mfUr4p8tP4uU/BFonW0DqTTMIhEgB2xIwIxQVg=";
  };

  cargoSha256 = "sha256-LnHpinNZZHrIEWrVW0t1ja5WN57/fmiSmZlB0ylau8Y=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs =
    if stdenv.isDarwin then [
      Foundation
      PCSC
    ] else [
      pcsclite
    ];

  meta = with lib; {
    description = "YubiKey plugin for age clients";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ vtuan10 ];
  };
}
