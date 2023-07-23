{ lib
, stdenv
, buildNpmPackage
, nodejs_18
, fetchFromGitHub
, python3
, darwin
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_18; };
in buildNpmPackage' rec {
  pname = "bitwarden-cli";
  version = "2023.5.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-ELKpGSY4ZbgSk4vJnTiB+IOa8RQU8Ahy3A1mYsKtthU=";
  };

  npmDepsHash = "sha256-G8DEYPjEP3L4s0pr5n2ZTj8kkT0E7Po1BKhZ2hUdJuY=";

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:prod";

  npmWorkspace = "apps/cli";

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
