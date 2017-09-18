{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mattermost-${version}";
  version = "4.2.0";

  src = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "0h52j1zmiij3g3rs10dr6xi2qdzqmb7xfj3rwbrlnvipjpnsa3v1";
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
