{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lCbxGW6+/r5AnsSXvrE7jYL1ZywcTlb4RK3MurL1JWg=";
  };

  vendorHash = "sha256-yXWeINubvfZ2S+3gVFsrzeVO3XXIiZ14qfK+9Bj3SV4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
