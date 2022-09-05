{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
    sha256 = "sha256-/PNGqveN4BSkURFVUpNgHDcPtz9vFhzdY8UK00AMaks=";
  };

  cargoSha256 = "sha256-3mrNS0zNgsG7mX3RileFLi5iw3SrlEQC96FSANjpKT8=";

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
