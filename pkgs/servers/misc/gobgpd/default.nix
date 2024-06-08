{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.27.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "refs/tags/v${version}";
    hash = "sha256-RxBAnElmQkrkMuIC0UpneJXN1OiPhaTPm/tYvc8QSg8=";
  };

  vendorHash = "sha256-wrgRQwisOHAhvRbvGXMW5VWkQuEifCwCo3usuxLie4A=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [
    "cmd/gobgpd"
  ];

  meta = with lib; {
    description = "BGP implemented in Go";
    mainProgram = "gobgpd";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
