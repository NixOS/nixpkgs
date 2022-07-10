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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KXqicTZ9GZlNj1AH3tMmOrC8zjXoEnqo4JJJTBdiI4E=";
  };

  cargoSha256 = "sha256-m/v4E7KHyLIWZHX0TKpqwBVDDwLjhYpOjYMrKEtx6/4=";

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
