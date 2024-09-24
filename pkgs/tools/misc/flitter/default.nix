{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "flitter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    rev = "v${version}";
    sha256 = "sha256-CjWixIiQFBoS+m8hPLqz0UR/EbQWgx8eKf3Y9kkgQew=";
  };

  cargoHash = "sha256-jkIdlvMYNopp8syZpIiAiekALUrRWWRKFFHYyMYRMg4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
