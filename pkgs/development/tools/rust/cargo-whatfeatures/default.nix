{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lCS0EDSNnCii98OBZlPwwq7LBociN7zo8FZJvxt9X4w=";
  };

  cargoHash = "sha256-SNhulId9naSBO7UxiiX7q0RIVJngflAO2UfpxvKDIF4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple cargo plugin to get a list of features for a specific crate";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou matthiasbeyer ];
  };
}
