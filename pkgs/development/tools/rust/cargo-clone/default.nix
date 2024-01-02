{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-clone";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "janlikar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lfg47kw07k4r795n0iixl5cnrb13g74hqlbp8jzbypr255bc16q";
  };

  cargoSha256 = "sha256-rJcTl5fe3vkNNyLRvm7q5KmzyJXchh1/JuzK0GFhHLk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  # requires internet access
  doCheck = false;

  meta = with lib; {
    description = "A cargo subcommand to fetch the source code of a Rust crate";
    homepage = "https://github.com/janlikar/cargo-clone";
    changelog = "https://github.com/janlikar/cargo-clone/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
