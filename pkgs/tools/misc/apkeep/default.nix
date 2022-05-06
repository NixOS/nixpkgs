{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SmzsFXS/geFpssy18pIluoCYGsJql9TAgYUNgAZlXmI=";
  };

  cargoSha256 = "sha256-bL79CW6X9pHx/Cn58KDxf8bVDwvrGRKkK9v/+Ygp5D4=";

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
