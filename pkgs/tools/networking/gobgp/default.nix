{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-iV5iohDwJ6LCtX2qvv+Z7jYRukqM606UlAROLb/1Fak=";
  };

  vendorSha256 = "sha256-hw2cyKJaLBmPRdF4D+GVcVCkTpIK0HZasbMyYfLef1w=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s" "-w" "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = with lib; {
    description = "A CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
