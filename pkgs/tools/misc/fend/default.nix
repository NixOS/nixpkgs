{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dz6vGRsWc7ubc/drj2Qw/of8AciPgVzc4++Eozg0Luo=";
  };

  cargoSha256 = "sha256-ietLhnblO9w+T4mV4eOSQVA6VUmMR/hHHTW9vCulSa8=";

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
