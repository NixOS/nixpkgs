{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "mattermost-${version}";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "0ngkdckd5bwh7ycnzspy9n16cqpk6pp9ifq8n19nkjlzynhsw2zd";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "0h52j1zmiij3g3rs10dr6xi2qdzqmb7xfj3rwbrlnvipjpnsa3v1";
  };

  goPackagePath = "github.com/mattermost/platform";

  buildPhase = ''
    runHook preBuild
    cd go/src/${goPackagePath}/cmd/platform
    go install
    runHook postBuild
  '';

  preInstall = ''
    mkdir -p $bin
    tar --strip 1 -C $bin -xf $webApp
  '';

  postInstall = ''
    ln -s $bin/bin/platform $bin/bin/mattermost-platform
  '';

  meta = with stdenv.lib; {
    description = "Open-Source, self-hosted Slack-alternative";
    homepage = https://www.mattermost.org;
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
