{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MQi8A7eWOShP/VhxuX4Uhz1ueLtKvOi1x4E7aFXEsQo=";
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
