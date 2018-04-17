{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

let
  version = "4.8.0";
  goPackagePath = "github.com/mattermost/mattermost-server";
  buildFlags = "-ldflags \"-X '${goPackagePath}/model.BuildNumber=nixpkgs-${version}'\"";
in

buildGoPackage rec {
  name = "mattermost-${version}";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "16yf4p0n3klgh0zw2ikbahj9cy1wcxbwg86pld0yz63cfvfz5ns4";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "0ykp9apsv2514bircgay0xi0jigiai65cnb8q77v1qxjzdyx8s75";
  };

  inherit goPackagePath;

  buildPhase = ''
    runHook preBuild
    cd go/src/${goPackagePath}/cmd/platform
    go install ${buildFlags}
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
    description = "Open-source, self-hosted Slack-alternative";
    homepage = https://www.mattermost.org;
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
