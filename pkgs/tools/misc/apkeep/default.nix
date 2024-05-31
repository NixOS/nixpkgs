{ lib
, stdenv
, fetchCrate
, rustPlatform
, openssl
, pkg-config
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-nPeXIzy9tYWeJrq1tIKXMILOjVnsAvsceY5dzz7+pYE=";
  };

  cargoHash = "sha256-0NyZmZ00zmGfndz47NMeh76SMmh0ap6ZfkKebX7pMfw=";

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
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    changelog = "https://github.com/EFForg/apkeep/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
    mainProgram = "apkeep";
  };
}
