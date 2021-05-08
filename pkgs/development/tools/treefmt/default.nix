{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "10mv18hsyz5kd001i6cgk0xag4yk7rhxvs09acp2s68qni1v8vx2";
  };

  cargoSha256 = "02455sk8n900j8qr79mrchk7m0gb4chhw0saa280p86vn56flvs0";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
