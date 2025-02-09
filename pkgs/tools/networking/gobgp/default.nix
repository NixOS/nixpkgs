{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-npPwAh7ReGVDGRi0cCs0/x2xCBCrUMsZl205BhEjxq4=";
  };

  vendorHash = "sha256-5eB3vFOo3LCsjMnWYFH0yq5+IunwKXp5C34x6NvpFZ8=";

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
