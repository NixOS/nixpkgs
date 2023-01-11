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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x4J8lE4Peenu3I7bZ3yoLpyukkMHD2re63GCni0cfnI=";
  };

  cargoSha256 = "sha256-Qp7AXy044G17FxR2sopN00cgX91A8TAydrwvJrAfhns=";

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
