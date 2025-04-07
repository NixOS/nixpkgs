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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-048WUDMMaTjGsNY54m2eKY1MdyX9llojIzGvbcC+Buc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Q8gh6RuNC2+pc13VksI0tiX/uVjhxYwnR5GRyQYRWLg=";

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
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
