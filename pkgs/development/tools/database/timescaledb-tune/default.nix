{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rOAXCru3m31lVFUyxywkuyKWUOJneA7ECMPyvAfw4mg=";
  };

  vendorHash = "sha256-8Q+KMYu1yiHEYS035NmCvxSgIS/+oRhhcZa6SwmvGgk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    mainProgram = "timescaledb-tune";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
