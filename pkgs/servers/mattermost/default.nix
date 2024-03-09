{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "8.1.11";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-jk4wNfybrJ/oGETDoVPmiqLMd55baML/Ko49qinhbU8=";
  } + "/server";

  # this can probably be removed again in versions newer than 8.1.10
  overrideModAttrs = (_: {
    preBuild = ''
      go mod tidy
    '';
  });

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    hash = "sha256-Aa6Un0YWHYMe2Ds/p+vMS9B38GUPRNH0ZQlCJ91uYD4=";
  };

  vendorHash = "sha256-NWliIJ/eusAYKhPdApTqdYf0gCo38HVcL/7P/zqkg+I=";

  subPackages = [ "cmd/mattermost" ];

  tags = [ "production" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mattermost/server/public/model.Version=${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildNumber=${version}-nixpkgs"
    "-X github.com/mattermost/mattermost/server/public/model.BuildDate=1970-01-01"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHash=v${version}"
    "-X github.com/mattermost/mattermost/server/public/model.BuildHashEnterprise=none"
    "-X github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"
    "-X github.com/mattermost/mattermost/server/public/model.MockCWS=false"
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
    mainProgram = "mattermost";
  };
}
