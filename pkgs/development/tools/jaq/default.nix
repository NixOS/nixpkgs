{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-P1NWkqRotL8h87iqxdVJhGVy9dw47fXeL10db1xsk00=";
  };

  cargoHash = "sha256-ZsY3PwbjNILYR+dYSp1RVqw0QV9PVB5bPSX1RdVUZUg=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
  };
}
