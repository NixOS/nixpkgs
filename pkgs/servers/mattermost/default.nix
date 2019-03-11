{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv }:

let
  version = "5.7.1";

  mattermost-server = buildGoPackage rec {
    name = "mattermost-server-${version}";

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "1k4rd8383bz9q23wgxnqcp69hcixaa0zd256h54wmwqw6fdn3bc0";
    };

    goPackagePath = "github.com/mattermost/mattermost-server";

    buildFlagsArray = ''
      -ldflags=
        -X ${goPackagePath}/model.BuildNumber=nixpkgs-${version}
    '';

  };

  mattermost-webapp = stdenv.mkDerivation {
    name = "mattermost-webapp-${version}";

    src = fetchurl {
      url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
      sha256 = "0rxbgd3cb9m7rf0yg1vpd1af6x6bn0jilb0pfqr46dg42a70dx09";
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
