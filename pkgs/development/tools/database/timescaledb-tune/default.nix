{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sCwMLVp4MCTJ5ZgALDs+of+upYMQeHz3xRk4YD2g23M=";
  };

  vendorSha256 = "sha256-n2jrg9FiR/gSrbds/QVV8Duf7BTEs36yYi4F3Ve+d0E=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
