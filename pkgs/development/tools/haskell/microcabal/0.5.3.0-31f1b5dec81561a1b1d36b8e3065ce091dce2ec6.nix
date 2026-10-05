import ./common.nix rec {
  # MicroCabal has important changes to mirror some changes in MicroHs but its
  # version releases are not frequent enough, so we need to use newer commits
  version = "0.5.3.0-${rev}";
  rev = "31f1b5dec81561a1b1d36b8e3065ce091dce2ec6";
  hash = "sha256-/oTcWGA43KQwniQKyZEPOlpmoRusDjb+k29GWc8wZzw=";
}
