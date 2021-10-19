{ lib, stdenv, fetchurl, fetchFromGitHub, buildGoModule, buildEnv }:

let
  version = "5.37.2";

  mattermost-server = buildGoModule rec {
    pname = "mattermost-server";
    inherit version;

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-kO5wSj/ApPhS2k9a9VjS3Qk55azNZeiFmevAxSkdGe0=";
    };

    vendorSha256 = null;
    doCheck = false;

    ldflags = [
      "-s" "-w" "-X github.com/mattermost/mattermost-server/v${lib.versions.major version}/model.BuildNumber=${version}"
    ];

  };

  mattermost-webapp = stdenv.mkDerivation {
    pname = "mattermost-webapp";
    inherit version;

    src = fetchurl {
      url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
      sha256 = "sha256-BzQVkOPo/f6O2ncQ0taS3cZkglOL+D+zBcfNYrpMgTM=";
    };

    installPhase = ''
      mkdir -p $out
      tar --strip 1 --directory $out -xf $src \
        mattermost/client \
        mattermost/i18n \
        mattermost/fonts \
        mattermost/templates \
        mattermost/config
    '';
  };

in
  buildEnv {
    name = "mattermost-${version}";
    paths = [ mattermost-server mattermost-webapp ];

    meta = with lib; {
      description = "Open-source, self-hosted Slack-alternative";
      homepage = "https://www.mattermost.org";
      license = with licenses; [ agpl3 asl20 ];
      maintainers = with maintainers; [ fpletz ryantm ];
      platforms = platforms.unix;
    };
  }
