{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-nZGDaoxGv5DrQY57v4by7SNlRWueKXGrndOKu+cZgDY=";
  };

  vendorSha256 = "sha256-FxfER3THsA7NRuQKEdWQxgUN0SiNI00hGUMVD+3BaG4=";

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
