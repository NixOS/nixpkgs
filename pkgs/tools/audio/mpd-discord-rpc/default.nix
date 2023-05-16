<<<<<<< HEAD
{ lib
=======
{ stdenv
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
<<<<<<< HEAD
, stdenv
, darwin
=======
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
<<<<<<< HEAD
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-discord-rpc";
    rev = "v${version}";
    hash = "sha256-fJHBQGc0+HjEALWuAWSts1l6NMookkut3Cm4e541iGw=";
  };

  cargoHash = "sha256-v5JN0Nqp/fGjjJaKrMWt2HWzxAnA1URf0P2Xq9lHNVQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc/";
    changelog = "https://github.com/JakeStanger/mpd-discord-rpc/blob/${src.rev}/CHANGELOG.md";
=======
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FYI0TlYyoT9h4fVjR1kp2Rn5qVppQhy6o09mPptTEMo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "discord-rpc-client-0.3.0" = "sha256-NzrsJYRe4jCZBkIEXbTG9xbHHJHQyIVnDWGx73of8Tw=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
