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
  # v0.4.1 is not released yet, but v0.4.0 has version discrepancy between Cargo.toml and Cargo.lock and does not build
  version = "0.4.0-unstable-2024-02-06";

in rustPlatform.buildRustPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = "79ab43a4087aa7e4e865cab6a181dfd24c6e7a90";
    hash = "sha256-gzbCeNZML2ygIy/H3uT9apahqI+4hmrTwgXvcZq4Xog=";
  };

  cargoHash = "sha256-Zvr2OH2pKtX60EApUSWhBV4cACMLl750UOiS3nN3J3Q=";

  passthru.tests.version = testers.testVersion {
    package = tmux-sessionizer;
    version = "0.4.1";
  };

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

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
