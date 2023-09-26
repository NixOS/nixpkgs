{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-hOt3xqrCs7akWyCv/6keiZN0ReF2adwiQNVibKFG3mk=";
  } + "/server";

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    hash = "sha256-cIfUIGp51dyfmY3LnV+1F9CX+y5XyTCez6R8TLLz9fo=";
  };

  vendorHash = "sha256-3OZUWg4e2h7g15FXxiFKk2EXceHP4phBTpyy/uY2Ni4=";

  subPackages = [ "cmd/mattermost" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost/server/public/model.Version=${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost/server/public/model.BuildDate=1970-01-01"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHashEnterprise=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"
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
    maintainers = with maintainers; [ ryantm numinit kranzes ];
  };
}
