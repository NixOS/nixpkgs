{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-vanity-address";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "warner";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SjzcVIQ9HwhP6Y/uCwXGSdZgrYcUQ9kE/Bow8pyOKNo=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cargoHash = "sha256-0bkyopkssqH0vfaWkFC3dV2o7Q3EuDEOM8JvRB9ekLU=";

  meta = with lib; {
    description = "Find Wireguard VPN keypairs with a specific readable string";
    homepage = "https://github.com/warner/wireguard-vanity-address";
    license = licenses.mit;
    maintainers = with maintainers; [ bcc32 ];
    mainProgram = "wireguard-vanity-address";
  };
}
