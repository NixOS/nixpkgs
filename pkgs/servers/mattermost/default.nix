{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv }:

let
  version = "4.10.0";

  mattermost-server = buildGoPackage rec {
    name = "mattermost-server-${version}";

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "02isw8qapp35pgriy4w1ar1ppvgc5a10j550hjbc1mylnhzkg1jf";
    };

    goPackagePath = "github.com/mattermost/mattermost-server";

    buildFlagsArray = ''
      -ldflags=
        -X ${goPackagePath}/model.BuildNumber=nixpkgs-${version}
    '';

    postInstall = ''
      ln -s $bin/bin/mattermost-server $bin/bin/platform
      ln -s $bin/bin/mattermost-server $bin/bin/mattermost-platform
    '';

  };

  mattermost-webapp = stdenv.mkDerivation {
    name = "mattermost-webapp-${version}";

    src = fetchurl {
      url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
      sha256 = "0pfj2dxl4qrv4w6yj0385nw0fa4flcg95kkahs0arwhan5bgifl5";
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

    meta = with stdenv.lib; {
      description = "Open-source, self-hosted Slack-alternative";
      homepage = https://www.mattermost.org;
      license = with licenses; [ agpl3 asl20 ];
      maintainers = with maintainers; [ fpletz ryantm ];
      platforms = platforms.unix;
    };
  }
