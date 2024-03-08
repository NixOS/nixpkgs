{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
    sha256 = "sha256-t6Y6gpMEpccCoyhG66FZEKHVNCbHblaqYZY1iJUZVUA=";
  };

  cargoHash = "sha256-fnoYVWpBn5Dil2o+u2MKQqd8dEKFE2i29Qz7cJae+gE=";

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
