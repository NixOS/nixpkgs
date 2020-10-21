{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1algvndpl63g3yzp3hhbgm7839njpbmw954nsiwf0j591spz4lph";
  };
  # tests are failing, reported at upstream: https://github.com/atanunq/viu/issues/40
  doCheck = false;

  cargoSha256 = "1jccaln72aqa9975nbs95gimndqx5kgfkjmh40z6chx1hvn4m2ga";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
