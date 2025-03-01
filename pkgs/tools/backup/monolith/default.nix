{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
  Security,
  SystemConfiguration,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t4FdTFXbKs7Xfw8dKoME7WDn+Fpe/uHPXyr5Wj+AXSA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FBxNK50ONmezXH8tVFpaBpSFVENS0uMO6mHcaeJq7Og=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
      SystemConfiguration
    ];

  checkFlags = [ "--skip=tests::cli" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Bundle any web page into a single HTML file";
    mainProgram = "monolith";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.cc0;
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
