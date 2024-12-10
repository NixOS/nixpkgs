{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-i7JVE1Y982QUNocd56gHbhRr5rBWqTv1YT5uDwpAlA8=";
  };

  cargoHash = "sha256-PZDie/lBextHu8EV/butg2pJZFfizeOEdD21I3XFoHk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
    mainProgram = "bore";
  };
}
