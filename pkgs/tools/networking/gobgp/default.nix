{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-UGRGJqeVWrt8NVf9d5Mk7k+k2Is/fwHv2X0hmyXvTZs=";
  };

  vendorHash = "sha256-9Vi8qrcFC2SazcGVgAf1vbKvxd8rTMgye63wSCaFonk=";

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
