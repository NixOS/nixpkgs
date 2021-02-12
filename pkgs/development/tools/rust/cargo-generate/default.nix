{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-RrDwq5VufMDsPlqRmBP3x2RUWU740L0L18noByO1IDY=";
  };

  cargoSha256 = "sha256-OKQovpf76AJuq5f8E958+Vzr7NObbqC1/h4RUCaDXPU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl  ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  meta = with lib; {
    description = "cargo, make me a project";
    homepage = "https://github.com/ashleygwilliams/cargo-generate";
    license = licenses.asl20;
    maintainers = [ maintainers.turbomack ];
  };
}
