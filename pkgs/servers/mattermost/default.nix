{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "mattermost-${version}";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "129rvmwf9c19jbdpiclysb870svs2fbhdybcal0jbmzgx2zr8qma";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "14gr7zzx77q862qccjcdwrzd6n8g2z8yngw8aa4g3q6hypsqi4v3";
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
