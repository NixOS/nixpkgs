{ lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
  version = "8.1.13";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-gfIRVeuHHxf99718e2dAFRIoP4GknosKfxRY7xCN1Xw=";
  } + "/server";

  # this can probably be removed again in versions newer than 8.1.10
  overrideModAttrs = (_: {
    preBuild = ''
      go mod tidy
    '';
  });

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    hash = "sha256-0Kft9OsK/3IZzFieQbKAF4ZlYBptPaoCclKPq7qewzE=";
  };

  vendorHash = "sha256-d0f+/C1JpfqygKNiJSG/pk6gZ0wbwY6gabXsjKWO91k=";

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
