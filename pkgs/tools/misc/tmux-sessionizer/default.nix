{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
, testers
, tmux-sessionizer
}: let

  name = "tmux-sessionizer";
  version = "0.3.2";

in rustPlatform.buildRustPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = "v${version}";
    hash = "sha256-8RQ67v2Cw681zikxYnq0Pb2ybh26w8mUbHKAC4TjYWA=";
  };

  cargoHash = "sha256-ZOWoUBna8U0A/sYwXMf4Z7Vi+KqM7VinWhmtO8Q0HtU=";

  passthru.tests.version = testers.testVersion {
    package = tmux-sessionizer;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller mrcjkb ];
    mainProgram = "tms";
  };
}
