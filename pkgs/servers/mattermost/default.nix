{ stdenv, fetchurl, fetchFromGitHub, buildGoPackage }:

let
  version = "4.9.1";
  goPackagePath = "github.com/mattermost/mattermost-server";
in

buildGoPackage rec {
  name = "mattermost-${version}";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mattermost-server";
    rev = "v${version}";
    sha256 = "0fyy14hqvsdjh1liyj8i570askc2jqsxcw6jrz9b78mw6qncgg9p";
  };

  webApp = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "139x1rfnv0p37ash5yph0ra7wsvlk7i2rmvgabvszh640ifdw70m";
  };

  inherit goPackagePath;

  postInstall = ''
    tar --strip 1 -C $bin -xf $webApp
    ln -s $bin/bin/platform $bin/bin/mattermost-platform
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $bin/bin/platform
  '';

  meta = with stdenv.lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = https://www.mattermost.org;
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
