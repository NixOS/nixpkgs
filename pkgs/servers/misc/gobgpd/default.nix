{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-gyaAtFJubvDiz5b7lk6vmPHIqr9ccWK3N2iy4LvYiMg=";
  };

  vendorSha256 = "sha256-RSsvFD3RvYKxdwPDGG3YHVUzKLgwReZkoVabH5KWXMA=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s" "-w" "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgpd" ];

  meta = with lib; {
    description = "BGP implemented in Go";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
