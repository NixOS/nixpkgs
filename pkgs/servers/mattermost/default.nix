{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "mattermost-${version}";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "05119h3x81p8plfjq99khfywc3plv2zynvf83vkhj48zqk61wvbq";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "0d30zj036nz6vwpiv0mn656j5r4br6y4x8iqc5jn785fiwk2pdls";
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
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
