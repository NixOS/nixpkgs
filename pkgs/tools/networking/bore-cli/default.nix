{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-ywdJH39OYLaM4st/DIcvvtIUzExpbAucMMpqouJL1yI=";
  };

  cargoSha256 = "sha256-ZnEVTFiPo3AFyo1BoV88X2nCqYzRK6PkcbawiR+QnV0=";

  buildInputs = lib.optional stdenv.isDarwin [
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
