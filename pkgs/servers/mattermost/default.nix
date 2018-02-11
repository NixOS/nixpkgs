{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "mattermost-${version}";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "158sfbg19sp165iavjwwfxx9s4y116yc5h3plsmvlxpdv674k7v3";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "1rbpl6zfmhfgzz2i1q2ym51ll6j54gk5p6ca99v9kjlm4ipcq9mv";
  };

  goPackagePath = "github.com/mattermost/mattermost-server";

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
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
