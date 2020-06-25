{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv }:

let
  version = "5.24.1";

  mattermost-server = buildGoPackage rec {
    pname = "mattermost-server";
    inherit version;

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "1iax9a81r3spbf1f570kz2rv8p8kw2jsbyb73myvhlgl7y00f94d";
    };

    goPackagePath = "github.com/mattermost/mattermost-server";

    buildFlagsArray = ''
      -ldflags=
        -X ${goPackagePath}/model.BuildNumber=nixpkgs-${version}
    '';

  };

  mattermost-webapp = stdenv.mkDerivation {
    pname = "mattermost-webapp";
    inherit version;

    src = fetchurl {
      url =
        "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
      sha256 = "14c8js503pvj3yfqfscn5anznl005a9fhbwybbd3qdamrfjsw87z";
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

in buildEnv {
  name = "mattermost-${version}";
  paths = [ mattermost-server mattermost-webapp ];

  meta = with stdenv.lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
