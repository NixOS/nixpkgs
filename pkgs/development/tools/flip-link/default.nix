{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x6l5aps0aryf3iqiyk969zrq77bm95jvm6f0f5vqqqizxjd3yfl";
  };

  cargoSha256 = "13rgpbwaz2b928rg15lbaszzjymph54pwingxpszp5paihx4iayr";

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    homepage = "https://github.com/knurling-rs/flip-link";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
