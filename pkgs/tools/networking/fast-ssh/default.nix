{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "fast-ssh";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "julien-r44";
    repo = "fast-ssh";
    rev = "refs/tags/v${version}";
    hash = "sha256-Wn1kwuY1tRJVe9DJexyQ/h+Z1gNtluj78QpBYjeCbSE=";
  };

  cargoHash = "sha256-CJ3Xx5jaTD01Ai7YAY4vB7RB5lU1BIXq7530B6+KeX4=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "TUI tool to use the SSH config for connections";
    homepage = "https://github.com/julien-r44/fast-ssh";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "fast-ssh";
  };
}
