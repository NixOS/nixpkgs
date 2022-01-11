{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.9.0";
  owner = "hairyhenderson";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "sha256-liy8cqn+hWoTOHchCY1LLu23tNvz7eGA+AN0d0APjC4=";
  };

  vendorSha256 = "sha256-Ph9z/Tom7O7V7yZ/On+etty+Bl653HiY/J3d3yfweeQ=";

  # some tests require network access
  postPatch = ''
    rm net/net_test.go
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/${owner}/${pname}/v3/version.Version=${rev}"
  ];

  meta = with lib; {
    description = "A flexible commandline tool for template rendering";
    homepage = "https://gomplate.ca/";
    maintainers = with maintainers; [ ris jlesquembre ];
    license = licenses.mit;
  };
}
