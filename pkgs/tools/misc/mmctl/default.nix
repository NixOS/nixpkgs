{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mmctl";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
    sha256 = "sha256-LPhFWZrQdusJKv0pDHWOv1gQ0EyVpT3nzkPYshh6pRw=";
  };

  vendorSha256 = null;

  checkPhase = "make test";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mmctl/v6/commands.Version=${version}"
  ];

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
  };
}
