{ lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "sha256-WDFay0XeaeNR/yX5if9Ab9XwzFF4cIGwBOrhc2rlX/c=";
  };

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-fIjasaaAEMPLaxo86MfASqTp/0WzzTDKJACKWuWby/A=";
  };

  vendorSha256 = "sha256-qZQXNVbJZDddVE+xk6F8XJCEg5dhhuXz68wcn2Uvmxk=";

  subPackages = [ "cmd/mattermost" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost-server/v6/model.Version=${version}"
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
