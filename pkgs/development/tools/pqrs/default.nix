{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
    sha256 = "1vx952ki1rhwfmr3faxs363m9fh61b37b0bkbs57ggn9r44sk1z2";
  };

  cargoSha256 = "1c482y83gzpvazdsxsx5n509mkqmyz640s18y4yg928mmqbsz9c4";

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
