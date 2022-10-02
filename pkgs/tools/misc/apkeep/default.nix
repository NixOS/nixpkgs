{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wFrpzemqBdhEO8cahSV9Qjw4HxCk+TgAVpGaa/IaO0Q=";
  };

  cargoSha256 = "sha256-6DAzNiNHmzOwg7RlRCorUCW33FTYdfLf6PnTygcL1ok=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
