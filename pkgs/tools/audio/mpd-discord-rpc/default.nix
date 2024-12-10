{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-discord-rpc";
    rev = "v${version}";
    hash = "sha256-Sdvrq9ChaSwjQDVjHVzcVLYbzyCHXsta1/Jo9hVkcDw=";
  };

  cargoHash = "sha256-w3ulSCbQBkDATe4yfgGSl7WMrUk3sYlS08UbgvGY/5s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc/";
    changelog = "https://github.com/JakeStanger/mpd-discord-rpc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "mpd-discord-rpc";
  };
}
