{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "mattermost-${version}";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "0imda96wgr2nkkxs2jfcqszx1fqgmbbrh7zqmgjh6ks3an1v4m3c";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "1ifxx17sm24c6sihg38lzpnb5x24m04bk25nn5hrw9iwc37lfzlp";
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
