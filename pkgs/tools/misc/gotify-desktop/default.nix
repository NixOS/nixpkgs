{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-vyOXZQ2X/LT/saBxcEbD96U34ufxjcWTHAobGI3bAE4=";
  };

  cargoHash = "sha256-MNxHJ1iirHj78wq6ChDjr6mQS0UmHPjVMs1EPFZyTV0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
    broken = stdenv.isDarwin;
    mainProgram = "gotify-desktop";
  };
}
