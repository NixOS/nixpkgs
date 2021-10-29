{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreFoundation
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "gobang";
  version = "0.1.0-alpha.5";

  src = fetchFromGitHub {
    owner = "tako8ki";
    repo = pname;
    rev = "v${version}";
    sha256 = "02glb3hlprpdc72ji0248a7g0vr36yxr0gfbbms2m25v251dyaa6";
  };

  cargoSha256 = "sha256-Tiefet5gLpiuYY6Scg5fjnaPiZfVl5Gy2oZFdhgNRxY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Rust";
    homepage = "https://github.com/tako8ki/gobang";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
