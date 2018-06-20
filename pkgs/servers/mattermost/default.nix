{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv }:

let
  version = "5.0.0";

  mattermost-server = buildGoPackage rec {
    name = "mattermost-server-${version}";

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "12wiw8k5is78ppazrf26y2xq73kwbafa9w75wjnb1839v2k9sark";
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
      sha256 = "1pal65di6w9idf3rwxh77la1v816h8kama1ilkbs40cpp2vazw3b";
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
