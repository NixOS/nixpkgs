{ lib
, buildGo118Module
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGo118Module rec {
  pname = "mattermost";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "sha256-oxZaOOV5pkK9HAi/AQ+MLZgfwvF6d/ArzYrXzUQGTDA=";
  };

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-NWVDPDqdx7mdWCr/qBi8HsUsCJbT63x37UZGecHsZr4=";
  };

  vendorSha256 = "sha256-0sKuk0klxeep8J96RntDP9DHsVM4vrOmsKXiaWurVis=";

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
    maintainers = with maintainers; [ fpletz ryantm numinit kranzes ];
  };
}
