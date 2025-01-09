{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  AppKit,
  Cocoa,
  Foundation,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "iay";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oNUK2ROcocKoIlAuNZcJczDYtSchzpB1qaYbSYsjN50=";
  };

  cargoHash = "sha256-bcMi8967dsJ3fL28XiUXfHz6CPB/RKSKsRvwMJtxEUA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      Cocoa
      Foundation
      Security
    ];

  NIX_LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [
    "-framework"
    "AppKit"
  ];

  meta = with lib; {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = licenses.mit;
    maintainers = with maintainers; [
      aaqaishtyaq
      omasanori
    ];
    mainProgram = "iay";
  };
}
