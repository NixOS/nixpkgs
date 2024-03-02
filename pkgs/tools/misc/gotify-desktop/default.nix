{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-TuqzwmKB48xcdzrAr7MvDA9JChobraESQZPKoy24mPE=";
  };

  cargoHash = "sha256-vg3al+eH9Q4D/T56jwWBlBT4IhuggiEVBl8WoZmUS2Y=";

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
