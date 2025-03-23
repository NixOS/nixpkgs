{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3cznGVpZISLD2TbsHYyYYUTD55NmgBdNJ44V4XfZ40k=";
  };

  # disable linker overrides on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-DjmMoATagWGK2DHMc6YB0u2X5x5hnqgCwIGe3+Wmdic=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fast, simple, recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
    mainProgram = "feroxbuster";
  };
}
