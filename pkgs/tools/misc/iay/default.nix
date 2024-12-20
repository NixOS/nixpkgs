{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, AppKit
, Cocoa
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "iay";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vk+1RbAmzRf2bbvbSpO+upVW4VrtYWM+5iiH73N+dsc=";
  };

  cargoHash = "sha256-+PpmxVPyRx/xF7jQGy/07xqALmdNp2uL3HZVOeRicqY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  NIX_LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [ "-framework" "AppKit" ];

  meta = with lib; {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = licenses.mit;
    maintainers = with maintainers; [ aaqaishtyaq omasanori ];
    mainProgram = "iay";
  };
}
