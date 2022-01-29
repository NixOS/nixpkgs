{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, pcsclite
, PCSC
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-yubikey";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "51910edfab4006a068864602469ff7db3766bfbe"; # no tag for this release
    sha256 = "sha256-mMqvBlGFdwe5BaC0bXZg/27BGNmFTTYbLUHWUciqxQ0=";
  };

  cargoSha256 = "sha256-OCbVLSmGx51pJ/EPgPfOyVrYWdloNEbexDV1zMsmEJc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    if stdenv.isDarwin then [
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
