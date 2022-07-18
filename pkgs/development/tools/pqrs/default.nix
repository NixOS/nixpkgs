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

  cargoSha256 = "0mjwazsnryhlfyzcik8052q0imz5f104x86k6b5rncbbbjaj17q1";

  meta = with lib; {
    broken = true; # since 2021-07-05 on hydra
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
