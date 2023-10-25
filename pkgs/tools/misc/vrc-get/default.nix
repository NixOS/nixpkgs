{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    sha256 = "03p3y6q6md2m6fj9v01419cy1wa13dhasd2izs7j9gl9jh69w9xm";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "03lv72gw39q7hibg2rzibvc1y0az30691jdf2fwn1m5ng0r7lqvp";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
  };
}
