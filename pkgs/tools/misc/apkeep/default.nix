{ lib
, stdenv
, fetchCrate
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PikUb9D9duMATo9hJgjuZUK3WXUKfnCDWJBE/bJI92c=";
  };

  cargoHash = "sha256-R58CzeI1Xho6kzjb9ktO7sr6TgM3Hf2VU0pK4hmb1v4=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    changelog = "https://github.com/EFForg/apkeep/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
