{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  Security,
  SystemConfiguration,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-/NgGlXYMxGxpX93SJ6gWgZW21cSSZsgo/WMvRuLw+Bw=";
  };

  # disable linker overrides on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-L5s+P9eerv+O2vBUczGmn0rUMbHQtnF8hVa22wOrTGo=";

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

  passthru.updateScript = nix-update-script { };

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
