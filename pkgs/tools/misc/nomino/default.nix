{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    sha256 = "sha256-CnI1vPUdjU5Npb10cMpL0pImbOoQ4r5v/Q0EFKy0yPc=";
  };

  cargoSha256 = "sha256-8mHMpxypBHiCEW6WR1kvuE5NtaL1mgZrCD8tvcrVLDQ=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
