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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x3dx4PdYSYd7wA/GGj9QYC8rK33FWATs2SnaOagGE80=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-12janO6zzlLge1uDLHHjGtycCPwkJXwII6LeG0586Fk=";

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
