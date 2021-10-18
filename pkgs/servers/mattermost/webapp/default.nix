{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mattermost-webapp";
  version = "5.37.2";

  src = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-BzQVkOPo/f6O2ncQ0taS3cZkglOL+D+zBcfNYrpMgTM=";
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

  meta = with lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };

}
