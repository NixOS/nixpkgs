{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv }:

let
  version = "5.1.0";

  mattermost-server = buildGoPackage rec {
    name = "mattermost-server-${version}";

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "069ihmfr6np991mbgg001y0kyafghn57nsv3kpyyvfmhv07p0qbc";
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
      sha256 = "1bm5nqnhk2w3sy8mvm81k7d65j6bgpvakgphgwqgnlm864i4253z";
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
