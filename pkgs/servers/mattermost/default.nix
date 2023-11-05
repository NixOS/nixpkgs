{ lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "7.8.13";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    hash = "sha256-l7uJZJe5t3Ve/JeSx93zQXCHlKpLwRNvo3ja5RgpOk4=";
  };

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    hash = "sha256-vYfxRkN4CU1645u7L+isUtJVMBV7Suoz6gKzbYJ4PvM=";
  };

  vendorHash = "sha256-gAAJIShw4SyJqOdhnATnOpn8YwkkGHEV3jD9FUhNIos=";

  subPackages = [ "cmd/mattermost" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost-server/v6/model.Version=${version}"
    "-X github.com/mattermost/mattermost-server/v6/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost-server/v6/model.BuildDate=1970-01-01"
    "-X github.com/mattermost/mattermost-server/v6/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost-server/v6/model.BuildHashEnterprise=v${version}"
    "-X github.com/mattermost/mattermost-server/v6/model.BuildEnterpriseReady=false"
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
