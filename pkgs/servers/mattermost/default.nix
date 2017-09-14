{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mattermost-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "0bp56i108pxsqcswxy1hdz3d8wq83lc29wcq6npimwx566rx4xhf";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
    ln -s ./platform $out/bin/mattermost-platform
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/platform
  '';

  meta = with stdenv.lib; {
    description = "Open-Source, self-hosted Slack-alternative";
    homepage = https://www.mattermost.org;
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ];
    platforms = [ "x86_64-linux" ];
  };
}
