{ lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "7.8.1";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "sha256-6aJkJCJmQHvSn5SHIPXj0nNLBuEez9BCYYMMlv3iZqQ=";
  };

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-KmzjhAkv1TpOlHtZnN/ifkQnzDqk1rN+fl4JStZRbXQ=";
  };

  vendorSha256 = "sha256-VvGLYOESyoBpFmIibHWxazliHcscMxf3KcQ46NQ4syk=";

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
