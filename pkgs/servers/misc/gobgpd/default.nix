{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgpd";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-Ofg+z8wUttqM1THatPFi0cuyLSEryhTmg3JC1o+16eA=";
  };

  vendorSha256 = "sha256-PWm7XnO6LPaU8g8ymmqRkQv2KSX9kLv9RVaa000mrTY=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  buildFlagsArray = ''
    -ldflags=
    -s -w -extldflags '-static'
  '';

  subPackages = [ "cmd/gobgpd" ];

  meta = with lib; {
    description = "BGP implemented in Go";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
