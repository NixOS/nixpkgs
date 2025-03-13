{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pgmAf9izrIun6+EayxSNy9glTUFd0x/uy5r/aijVi4U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TO2YCUmD+K4X7ArAPGCDhTH2W2UG8Ezr+yZjaQJTL0A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
    ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    changelog = "https://github.com/rust-motd/rust-motd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rust-motd";
  };
}
