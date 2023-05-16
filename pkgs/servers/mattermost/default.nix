{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "mattermost";
<<<<<<< HEAD
  version = "7.10.3";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost";
    rev = "v${version}";
    hash = "sha256-nzQUkcCFEZYvqMLRv1d81pfoz/MDYjWetGLtFXf8H/Q=";
=======
  version = "7.8.3";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    hash = "sha256-MJAYKBMQEf82YkDOpLHnL7Jxlz6i0K0B8E99pRxGHgc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  webapp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
<<<<<<< HEAD
    hash = "sha256-oD67sTyTvB0DVcw3e6x79Y4K8xlX75YreRwnc9olTy4=";
  };

  vendorHash = "sha256-7YxbBmkKeb20a3BNllB3RtvjAJLZzoC2OBK4l1Ud1bw=";

  patches = [
    (fetchpatch {
      # Current version was set to 7.10.4 in the v7.10.3 tag, reverting it so `mattermost version` exposes the correct version
      # and to make smoke tests happy
      url = "https://github.com/mattermost/mattermost/commit/fbdadeacc85ae47145f69ffb766d4105aede69d5.patch";
      hash = "sha256-9BNEc5VefRuPKb3/rQNiekNbAIBRsjAtdCKUVrh9BuY=";
      revert = true;
    })
  ];
=======
    hash = "sha256-4VOEDrCKZI5HR5U2m49Dfbs5Mc+i8l4N41jIy8+5D1k=";
  };

  vendorHash = "sha256-VvGLYOESyoBpFmIibHWxazliHcscMxf3KcQ46NQ4syk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
