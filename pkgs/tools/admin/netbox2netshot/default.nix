{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "netbox2netshot";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "netbox2netshot";
    rev = version;
    hash = "sha256-PT/eQBe0CX1l6tcC5QBiXKGWgIQ8s4h6IApeWyb8ysc=";
  };

  cargoHash = "sha256-/T+6cjWG8u/Mr8gtBOXbEEZOO0pDykEpNIVTgooAmuw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "Inventory synchronization tool between Netbox and Netshot";
    homepage = "https://github.com/scaleway/netbox2netshot";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
    mainProgram = "netbox2netshot";
  };
}
