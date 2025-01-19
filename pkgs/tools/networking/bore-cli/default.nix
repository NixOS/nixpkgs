{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-Wkhcv8q/dGRJqG7ArsnsPsRBnXdScGedwxunbOzAjyY=";
  };

  cargoHash = "sha256-vwvDtzShlQQO/oAnjbqDIP3fUdcH1kEmFR7fyV+uYbY=";

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
