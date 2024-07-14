{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-HdGRZrMukIQLxTmwTVB/zUlnrhDjq5b6ree7aqx8pRE=";
  };

  vendorHash = "sha256-wrgRQwisOHAhvRbvGXMW5VWkQuEifCwCo3usuxLie4A=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s" "-w" "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = with lib; {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
}
