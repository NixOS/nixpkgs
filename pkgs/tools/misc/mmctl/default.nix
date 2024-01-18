{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mmctl";
  version = "9.2.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-53L2F20vaLLxtQS3DP/u0ZxLtnXHmjfcOMbXd4i+A6Y=";
  } + "/server";

  vendorHash = "sha256-v8aKZyb4emrwuIgSBDgla5wzwyt6PVGakbXjB9JVaCk=";

  patches = [ ./0001-module-replace-public.patch ];

  subPackages = [ "cmd/mmctl" ];

  checkPhase = "go test -tags unit -timeout 30m ./cmd/mmctl/...";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost/server/public/model.Version=${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost/server/public/model.BuildDate=1970-01-01"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHashEnterprise=none"
    "-X github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"
  ];

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom mgdelacroix ];
    mainProgram = "mmctl";
  };
}
