{ lib
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, rustPlatform
, Security
, stdenv
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "wapm-cli";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${version}";
    sha256 = "sha256-QgQQ0lbr7Ggd2HmKlu/5TMFISxrwKWstoAq8e776l8I=";
  };

  cargoSha256 = "sha256-F4BvP1yMJ06QgocD6InwkfHtJIsEkOfxuaaalksJCew=";

  buildInputs = lib.optionals stdenv.isLinux [ openssl pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "A package manager for WebAssembly modules";
    homepage = "https://docs.wasmer.io/ecosystem/wapm";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lucperkins ];
  };
}
