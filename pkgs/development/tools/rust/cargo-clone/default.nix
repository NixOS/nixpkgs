{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-clone";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "janlikar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-al+C3p9jzPbykflt3WN+SibHm/AN4BdTxuTGmFiGGrE=";
  };

  cargoHash = "sha256-sQVjK6i+wXwOfQMvnatl6PQ1S+91I58YEtRjzjSNNo8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Security
    SystemConfiguration
  ];

  # requires internet access
  doCheck = false;

  meta = with lib; {
    description = "A cargo subcommand to fetch the source code of a Rust crate";
    mainProgram = "cargo-clone";
    homepage = "https://github.com/janlikar/cargo-clone";
    changelog = "https://github.com/janlikar/cargo-clone/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
