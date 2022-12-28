{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
    sha256 = "sha256-fqxPQUcd8DG+UYJRWLDJ9RpRkCWutEXjc6J+w1qv8PQ=";
  };

  cargoSha256 = "sha256-/nfVu8eiQ8JAAUplSyA4eCQqZPCSrcxFzdc2gV95a2w=";

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
