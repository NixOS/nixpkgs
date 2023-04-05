{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-h5Xwsr61h52zb5HNPySKVjfYW96Fff7nwZUAL6vK9ko=";
  };

  cargoSha256 = "sha256-QyaQM8z5v0LgskkmZ/8ekZwxNrt8sq91BbnjvIqa2nI=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
