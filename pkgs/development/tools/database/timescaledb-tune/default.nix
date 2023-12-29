{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YgG8yuHnJrhrqJHNUkMjJvKNzEQ3ClY9OQzt+ET4LEk=";
  };

  vendorHash = "sha256-8Q+KMYu1yiHEYS035NmCvxSgIS/+oRhhcZa6SwmvGgk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
