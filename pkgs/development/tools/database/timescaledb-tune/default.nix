{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6xMdOqLfD3NQksmcD7rlTW3xoW2Fi6OmwbpjIj9A/tw=";
  };

  vendorSha256 = "sha256-n2jrg9FiR/gSrbds/QVV8Duf7BTEs36yYi4F3Ve+d0E=";

  meta = with lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
