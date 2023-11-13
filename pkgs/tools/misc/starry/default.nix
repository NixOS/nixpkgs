{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "starry";
  version = "2.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CPEMjg70MXlV+ruYnEHpTmqlc27NMTUKTR4/fpQmYcI=";
  };

  cargoHash = "sha256-d6icXOgju4qEV2+J+G09/xeQMIX3/4XUFmuWfD/Cqhc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Current stars history tells only half the story";
    homepage = "https://github.com/Canop/starry";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starry";
  };
}
