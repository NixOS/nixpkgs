{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "9.2.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-53L2F20vaLLxtQS3DP/u0ZxLtnXHmjfcOMbXd4i+A6Y=";
  } + "/server";

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    hash = "sha256-/6SKqSXH8sW70rYt4MmABWNQP/JDAA1lxuvCJhqEoTI=";
  };

  vendorHash = "sha256-v8aKZyb4emrwuIgSBDgla5wzwyt6PVGakbXjB9JVaCk=";

  patches = [ ./0001-module-replace-public.patch ];

  subPackages = [ "cmd/mattermost" ];

  tags = [ "production" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost/server/public/model.Version=${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost/server/public/model.BuildDate=n/a"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHashEnterprise=none"
    "-X github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"
    "-X github.com/mattermost/mattermost/server/public/model.MockCWS=false"
    "-X github.com/mattermost/mattermost/server/public/model.MattermostGiphySdkKey="
  ];

  postInstall = ''
    tar --strip 1 --directory $out -xf $webapp \
      mattermost/{client,i18n,fonts,templates,config}

    # For some reason a bunch of these files are executable
    find $out/{client,i18n,fonts,templates,config} -type f -exec chmod -x {} \;
  '';

  passthru.tests.mattermost = nixosTests.mattermost;

  meta = with lib; {
    description = "Mattermost is an open source platform for secure collaboration across the entire software development lifecycle";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ ryantm numinit kranzes mgdelacroix ];
  };
}
