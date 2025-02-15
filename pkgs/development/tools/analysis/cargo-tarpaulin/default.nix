{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  curl,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    hash = "sha256-ghmsglKQrHa1nyUAj4oXry8GR0u0qdeY+fmWTh+S64M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-niwQi6spvul1jIYsjwAVksuHo/cTm2QoROuaPv8vuNs=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
      Security
    ];

  doCheck = false;

  meta = with lib; {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      hugoreeves
    ];
  };
}
