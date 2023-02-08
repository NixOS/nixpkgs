{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csv2parquet";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "domoritz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-499DC0kLvvP5Oq2WYRb9BIppTdfm41u8hwrPU8b66Zw=";
  };

  cargoHash = "sha256-GoUmr1NArOyGx1A9E9K/Od0xXR2YxZqBcBdYFumgIJU=";

  meta = with lib; {
    description = "Convert CSV files to Apache Parquet";
    homepage = "https://github.com/domoritz/csv2parquet";
    license = licenses.mit;
    maintainers = with maintainers; [ john-shaffer ];
  };
}
